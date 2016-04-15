# docs generator

Given a source code file as input, you need to generate YAML documentation by parsing the docblocks. All docblocks are written immediately preceding the entity it documents. The docblocks follow special notations, as described below:

## Class
```
/** @class The class description
 *  @author The author of the class
 */
class Sample

Resulting into YAML:
---
  author: "Foo Bar <foo@bar.com>"
  class: "Person"
  desc: "Represents user info"
  methods:
  properties:
  subclasses: []
  super:
```

## Properties
```
// @var type and object this represents
int sample

Resulting into YAML:

desc: "a string for name of the person"
type: "string"
var: "name"
```

## Methods
```
/** @method The description of the method
 *  @param One for each argument, describing the argument
 */
void get_val();

Resulting into YAML:

desc: "accessor for name property"
method: "get_name"
params: []
return: "string"
virtual: false
```

## Notes

* A source file will contain only one outermost class.
* Classes can have subclasses, in which case the YAML structure of the subclass will follow the same YAML structure as above, but will be nested into the list of subclasses for the parent class.
* Methods can be virtual or not, which is mentioned as a boolean value in the YAML for the method. This is required.
* The docblock which occurs anywhere other than just before the declaration of an entity, must not be considered.
* The order of variables, methods, params and subclasses should be in the order in which they appear in the code.
* Source code will follow standard indentation and spacing.
* Docblocks may contain invalid @key markers, which are expected to be ignored.

## INPUT

Source Code

## OUTPUT

YAML representing the hierarchy of information collected for documentation by parsing the docblocks. The keys in the object are expected in order specified above in parsed docs. No newline at the end of output.

