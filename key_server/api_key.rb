# E1, generate: new key into open         R W
# E2, random: get open key, block it      R
# E3, unblock: unlobk a key, put in open    R W
# E4, delete: delete a key from open/block        
# E5, ping: keep alive key for 300s       R

# F1, purge: check timeout 300s and delete key  
# F2, release: check timeout 60s and unblock key
# F3, read: check for timeouts and return value

# key   state     t   open  block
#     generate  -1    Y   
#     random    now       Y
#     unblock   -1    Y   
#     delete    -1    
#     ping    now       Y

# todo rmdir_p

require 'fileutils'

class ApiKey
  ALL_ROOT = '/tmp/store/all/'
  OPEN_ROOT = '/tmp/store/open/'
  BLOCK_ROOT = '/tmp/store/blocked/'

  attr_reader :value

  def initialize(value)
    @value = value
    @path = value.scan(/.{1,2}/).join('/')
    puts @value + ": " + @path
  end

  private

  def exists(path)
    File.exists?(path)
  end

  def mkdir_p(path)
    FileUtils.mkdir_p(path)
  end

  def rmdir_p(path)
    while ApiKey.list(path).length == 0 && (path+"/") != OPEN_ROOT do 
      puts "Deleting " + path + " " + OPEN_ROOT
      FileUtils.rmdir(path)
      path = File.dirname(path)
    end
  end

  def write(value = nil)
    path = ALL_ROOT + @path + '/key.txt'
    value = Time.now.getutc.to_i unless value
    File.open(path, 'w') do |f|
      f.puts value.to_s
    end
  end

  def read
    path = ALL_ROOT + @path + '/key.txt'
    r = -1
    File.open(path, 'r') do |f|
      line = f.gets.chomp
      r =line.to_i
    end
    r
  end

  def self.list(dir)
    Dir.entries(dir).select do |entry| 
      File.directory? File.join(dir,entry) and !(entry =='.' || entry == '..') 
    end
  end

  public

  def read?
    if exists(ALL_ROOT + @path)
      # if open or block, check timeouts
      if exists(OPEN_ROOT + @path) || exists(BLOCK_ROOT + @path)
        t = read
        unless t == -1
          delta = Time.now.getutc.to_i - t
        else
          delta = 0
        end

        if delta > 300
          puts "Delta > 300, Deleting ..."
          delete
        elsif delta > 60
          puts "Delta > 60, Unblocking ..."
          unblock
        end 
      end

      # indicates existence in ALL (open, block, deleted)
      return true
    end

    # indicates non existence in ALL
    return false
  end

  def generate?
    unless read?
      mkdir_p(ALL_ROOT + @path)
      write(-1)
      mkdir_p(OPEN_ROOT + @path)
    else
      return false
    end
  end

  def self.random(count = 0)
    parts = []
    dir = ALL_ROOT

    puts ""
    puts "RANDOM #{count}"

    if count > 15
      if count % 2 == 0
        dir = OPEN_ROOT
      else
        dir = BLOCK_ROOT
      end
    elsif count > 25 && list(OPEN_ROOT).length == 0
      return nil
    end

    while true do
      dirlist = self.list(dir)
      break if dirlist.length == 0
      part = dirlist[Random.rand(dirlist.length)]
      parts << part
      dir += '/' + part
    end

    if parts.length == 0
      return nil
    end

    key = ApiKey.new(parts.join(''))
    key.read?

    if key.block
      return key
    else
      self.random(count + 1)
    end
  end

  def block
    if exists(OPEN_ROOT + @path)
      rmdir_p(OPEN_ROOT + @path)
      mkdir_p(BLOCK_ROOT + @path)

      write
      puts "Blocked"
      return true
    end

    return false
  end

  def unblock
    if exists(BLOCK_ROOT + @path)
      rmdir_p(BLOCK_ROOT + @path)
      mkdir_p(OPEN_ROOT + @path)

      puts "Unblocked"
      write(-1)
      return true
    end

    return false
  end

  def delete
    if exists(OPEN_ROOT + @path)
      rmdir_p(OPEN_ROOT + @path)
    elsif exists(BLOCK_ROOT + @path)
      rmdir_p(BLOCK_ROOT + @path)
    end

    puts "Deleted"
    write(-1)
    return read?
  end

  def ping 
    if (read? && exists(BLOCK_ROOT + @path))
      write
      puts "Pinged"
      return true
    end
    return false
  end

  def to_s
    @value
  end
end


if __FILE__ == $0
  #api = ApiKey.new("abcdefghijk")
  #puts api.read?

  #puts api.generate?
  #puts api.block
  #puts api.ping

  #puts api.unblock
  #puts api.read?

  puts ApiKey.random
end




