class_name CreditSectionData extends Resource

## The name appearing at the top of a section in credits (example: Programming).
@export var section_name:String = ""
## A list of images used to display company logos or any image.
@export var logo_images:Array[Resource]
## The list of names displayed in the section of credits.
@export var list_of_names:Array[String]
