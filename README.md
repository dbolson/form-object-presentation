# Objectify Your Forms: Beyond Basic User Input

Sample application to demonstrate form objects.

## Abstract

User input contains a lot of potential complexity. A simple CRUD form can turn into an unmaintainable mess when we introduce accepts_nested_attributes_for to deal with associations, validating first this model then that one, manually adding validation errors, and finally saving the whole thing.

What if we could use good old object oriented design principles to make forms a pleasure to deal with? Form objects give us a much simpler way to build any sort of form we want that is straight forward to build, test, and maintain.

We will build a complicated form using the default Rails helpers, and then we'll rebuild it with a form object and let the audience decide which method they prefer.

## The Code

### Branches

* __master__ - original version using `accepts_nested_attributes_for`.
* __new-feature-rails-way__ - original version with additional feature.
* __form-object-implementation__ - second version using form objects.
* __new-feature-form-object__ - second version with additional feature.
