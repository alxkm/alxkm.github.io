---
layout: post
title: Reflection after Java 9
date: 2024-08-23
author: alxkm
tags:
  - java
  - java 9
  - reflection
  - engineering
  - reflection-api
categories:
  - Research
  - Guide
---

### Reflection after Java 9

Beyond the Horizon: Navigating Reflection in Java Post-Java 9

![](https://cdn-images-1.medium.com/max/2000/1*gQ15sOJfUKKYA24BOnAdjg.jpeg)

Java reflection has not been removed in versions after Java 9, but its use has been impacted by the introduction of the module system and other changes. Here are the key points regarding the limitations and changes to Java reflection in versions after Java 9:

**Module System:**

* **Stricter Encapsulation:** With the module system introduced in Java 9, stronger encapsulation means that reflection cannot access non-exported types and members by default. This is a significant change from the pre-Java 9 era where reflection could access most types and members regardless of their visibility.

* **Command-Line Options:** To maintain backward compatibility, the --add-exports and --add-opens options can be used to relax these restrictions at runtime. These options allow specific packages to be exported or opened to other modules or to all unnamed modules.

**AccessibleObject Changes:**

* **setAccessible Restrictions:** The setAccessible(true) method is still available, but its use is restricted. In the context of modules, this method will not work if it tries to break module encapsulation unless the module is explicitly opened or exported for deep reflection.

* **Reflection Configuration:** Reflective access to non-public members across module boundaries requires configuration, which can be specified via command-line arguments or module-info descriptors.

**Performance and Security Enhancements:**

* **Performance Improvements:** Ongoing performance optimizations have been made to reflection-related APIs to reduce overhead.

* **Security Enhancements:** The increased encapsulation provided by the module system enhances security by preventing unintended or malicious reflective access to internal APIs.

**Deprecation of Unsafe Practices:**

* **Internal APIs:** The use of internal APIs (like sun.misc.Unsafe) via reflection is strongly discouraged and alternatives are provided. This helps in writing safer and more maintainable code.

**Future Directions:**

* **Security Manager:** The Java Security Manager, which can impose restrictions on reflective access, is planned to be phased out in future Java versions. This will change how security policies apply to reflection.

* **Reflection Configuration Files:** Introduced with GraalVM native image support, reflection configuration files allow for specifying which classes and members should be available for reflection, which is particularly useful for ahead-of-time compilation scenarios.

Reflection in Java has not been removed but has been subject to more restrictions and changes aimed at improving security and maintainability. The introduction of the module system in Java 9 is the most significant change, imposing stricter encapsulation that affects how and when reflection can be used. Developers need to be more explicit about reflective access, particularly in modular applications, and may need to adjust their code or use configuration options to accommodate these changes.

## Using Reflection in Java 9

**Accessing Public Members of the Same Module:**

* If you’re working within the same module, accessing public members via reflection remains straightforward. You can use reflection APIs like Class.forName(), Class.getDeclaredMethods(), Field.get(), etc., as before.

**Accessing Public Members of Other Modules:**

* If you need to access public members of other modules via reflection, those modules must explicitly export the packages containing the desired classes and members. If the module exporting the package does not explicitly export it for reflective access, you need to use the --add-exports command-line option to allow reflection access at runtime.

**Accessing Non-Public Members:**

* Accessing non-public members via reflection requires that the module containing the class you’re trying to access explicitly opens its packages to allow deep reflective access. You can achieve this using the --add-opens command-line option.

**Using Reflection in Module Descriptors (module-info.java):**

* If you’re working with modules, you might need to use reflection to interact with module descriptors themselves. For example, you can use reflection to get information about modules loaded at runtime or manipulate the module graph. Accessing such information doesn’t generally require additional permissions, but if you’re accessing non-public members of module descriptors, you still need to follow the rules mentioned above.

**Handling Security Restrictions:**

* When using reflection in Java 9 and later, you need to be aware of security restrictions. By default, reflection is subject to stronger encapsulation rules imposed by the module system. This means that code that previously relied on reflective access to internal APIs may need to be revised.

**Handling Exceptions:**

* When using reflection, be prepared to handle various exceptions that may occur, such as ClassNotFoundException, NoSuchMethodException, IllegalAccessException, etc.

Here’s a basic example demonstrating how to use reflection in Java 9:

Define module:

    module com.example.myapp {
        // exports packages
        exports com.example.myapp.utils;
    }

Class definition:

    package com.example.myapp.utils;
    
    public class MyClass {
        public void myMethod() {
            System.out.println("Hello, Reflection!");
        }
    }

Usage example:

    import com.example.myapp.utils.MyClass;
    
    import java.lang.reflect.Method;
    
    public class Main {
        public static void main(String[] args) throws Exception {
            // Using reflection to get class and method
            Class<?> clazz = Class.forName("com.example.myapp.utils.MyClass");
            Method method = clazz.getMethod("myMethod");
    
            // Creating an instance and invoking the method
            MyClass myObject = (MyClass) clazz.getDeclaredConstructor().newInstance();
            method.invoke(myObject);
        }
    }

Remember to compile and run your code with appropriate command-line options if you encounter access issues due to module encapsulation.

## Before/After Java 9

Before Java 9, reflection usage was less restricted, as there was no module system enforcing encapsulation boundaries. Here’s how you would typically use reflection before and after Java 9:

### Before Java 9:

    import java.lang.reflect.Method;
    
    public class Main {
        public static void main(String[] args) throws Exception {
            // Using reflection to get class and method
            Class<?> clazz = Class.forName("com.example.myapp.utils.MyClass");
            Method method = clazz.getMethod("myMethod");
    
            // Creating an instance and invoking the method
            Object myObject = clazz.newInstance(); // Deprecated in Java 9
            method.invoke(myObject);
        }
    }

### After Java 9:

    import java.lang.reflect.Method;
    
    public class Main {
        public static void main(String[] args) throws Exception {
            // Using reflection to get class and method
            Class<?> clazz = Class.forName("com.example.myapp.utils.MyClass");
            Method method = clazz.getMethod("myMethod");
    
            // Creating an instance and invoking the method
            Object myObject = clazz.getDeclaredConstructor().newInstance(); // Java 9 and later
            method.invoke(myObject);
        }
    }

## Differences:

**Module System (Java 9 and later):**

* In Java 9 and later, modules enforce encapsulation boundaries, requiring explicit configuration to access types and members via reflection. This is reflected in the examples by the need to configure module exports and opens to allow reflective access.

**newInstance() vs getDeclaredConstructor().newInstance():**

* Before Java 9, you could use newInstance() directly on the Class object to create a new instance of the class. This method is deprecated in Java 9 and later due to its lack of ability to handle constructor arguments. Instead, you use getDeclaredConstructor().newInstance() to create instances, which allows passing constructor arguments if needed.

**Security Considerations:**

* In Java 9 and later, there are stricter security checks on reflective access, especially across module boundaries. This means you may encounter more security-related exceptions if your code violates encapsulation boundaries.

**Command-Line Options:**

In Java 9 and later, you may need to use command-line options like --add-exports and --add-opens to allow reflective access to certain packages and types, especially if they are not exported or opened by default. This is not required in pre-Java 9 code.

## Conclusion

The introduction of the module system in Java 9 brought significant changes to how reflection is used and accessed. Before Java 9, reflection was more permissive, allowing access to most types and members without strict encapsulation boundaries. However, with the module system, stronger encapsulation is enforced, requiring explicit configuration to access types and members via reflection.

In pre-Java 9 code, developers could use newInstance() directly on the Class object to create instances, but this method is deprecated in Java 9 and later in favor of getDeclaredConstructor().newInstance(), which allows passing constructor arguments.

Additionally, security considerations have become more prominent in Java 9 and later versions, with stricter security checks on reflective access, especially across module boundaries. This means developers may encounter more security-related exceptions if their code violates encapsulation boundaries.

To address these changes, developers need to be more explicit about reflective access, particularly in modular applications, and may need to adjust their code or use configuration options like --add-exports and --add-opens to accommodate the new module system requirements.

Overall, while reflection remains a powerful tool in Java, its usage has evolved in Java 9 and later versions to align with the modular and more secure nature of modern Java applications. By understanding and adapting to these changes, developers can continue to leverage reflection effectively while ensuring the integrity and security of their Java applications.
