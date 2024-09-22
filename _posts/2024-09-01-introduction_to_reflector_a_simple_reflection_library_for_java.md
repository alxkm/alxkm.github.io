---
layout: post
title: Introduction to Reflector A Simple Reflection Library for Java
date: 2024-09-01
author: alxkm
tags:
  - java
  - reflector
  - library
  - reflection
  - engineering
  - reflection api
categories:
  - Research
  - Guide
---

### Introduction to Reflector: A Simple Reflection Library for Java

![](https://cdn-images-1.medium.com/max/2000/1*oxQAqm_oDH-5DqJRlLLsMA.jpeg)

Discovering Reflector: Simplifying Reflection in Java with an Introduction to a User-Friendly Library

In this article, we will explore [**Reflector](https://github.com/alxkm/reflector)**, a small and straightforward reflection library designed for Java. Reflector aims to simplify various reflection tasks, making it easier for developers to interact with class properties and methods at runtime.

I wrote this library as a pet project. Maybe someone will find this library useful or production or probably educational purposes.

Link for library: [https://github.com/alxkm/reflector](https://github.com/alxkm/reflector)

## Key Features of Reflector

Reflector offers a range of functionalities that can be highly useful in various scenarios. The main capabilities of this library include:

* **Accessing Class Methods**: Retrieve all methods of a class, whether they are private or public.

* **Accessing Class Fields**: Fetch all fields of a class.

* **Annotated Fields Selection**: Select fields that are annotated with specific annotations.

* **Field Manipulation**: Clear or modify certain fields.

* **Instance Invocation**: Create new instances of a class dynamically.

* **Method Invocation**: Call methods on an object.

* **Field Reading**: Read the value of an object’s field.

* **Field Reading as Map**: Read an object’s field values and represent them as a map.

* **Class Metadata**: Get class name, package, superclass, and other metadata.

* **Method Retrieval**: Obtain specific methods, including declared and default interface methods.

## Requirements and Considerations

Reflector requires **Java 8** to run. The library deliberately avoids using some of the more advanced features of Java 8 to keep the code more straightforward and accessible. Additionally, the formatting of the library code does not strictly adhere to the official Java code style to maintain clarity.

## Quick Start with Reflector

To get you started quickly, here is a simple usage example of how to use Reflector to get all private fields of a class:


    List<Field> fields = ReflectionUtils.getAllPrivateFields(List.class);

So as you see, this is very simple usage.

## Usage Examples

Reflector offers a wide range of functionalities that can be particularly useful in various development scenarios. Here are some of the primary features and their usage examples:

### Accessing Private Fields

Retrieve all private fields of a class:

    List<Field> fields = ReflectionUtils.getAllPrivateFields(List.class);v

### Accessing Public and Protected Methods

Fetch all public and protected methods of a class:

    List<Method> allPublicProtectedMethods = ReflectionUtils.getAllPublicProtectedMethods(List.class);

### Accessing Private Methods

Get all private methods of a class:

    List<Method> allPrivateMethods = ReflectionUtils.getAllPrivateMethods(List.class);

### Accessing Annotated Fields

Select all fields annotated with a specific annotation, such as @Autowired:

    List<Field> fields = ReflectionUtils.getAllAnnotatedFields(DataService.class, Autowired.class);

### Creating an Instance Dynamically

Instantiate a class dynamically using its full class name and constructor parameters:

    String fullClassNameWithPackage = "org.data.model.User";
    Object[] params = {"Name", "Surname"};
    User instance = (User) ReflectionUtils.invokeInstance(fullClassNameWithPackage, params);

### Finding a Method by Name

Retrieve a specific method by its name:

    Method method = ReflectionUtils.findMethod(Person.class, "getId");

### Accessing Declared Methods

Get a list of declared methods of a class:

    List<Method> methods = ReflectionUtils.getDeclaredMethodsList(Person.class);

Alternatively, retrieve an array of declared methods:

    Method[] methods = ReflectionUtils.getDeclaredMethods(Person.class);

### Accessing Default Methods on Interfaces

Find all default methods on interfaces implemented by a class:

    List<Method> methods = ReflectionUtils.findDefaultMethodsOnInterfaces(Person.class);

## Requirements and Considerations

Reflector requires **Java 8** to function. The library intentionally avoids using some of the more advanced features of Java 8 to keep the code more accessible and straightforward. Additionally, the formatting of the library code does not strictly adhere to the official Java code style to maintain clarity.

## Conclusion

Reflector is a powerful tool for Java developers, simplifying reflection operations and enhancing productivity. In the following sections, we will explore each feature in more detail, providing comprehensive explanations and additional examples to help you make the most out of Reflector. Whether you need to access private fields, invoke methods dynamically, or work with annotations, Reflector offers the functionality you need in a simple and efficient manner.
