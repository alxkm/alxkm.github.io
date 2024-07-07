---
layout: post
title: Java record comparison, Lombok @Data
date: 2024-07-03
author: alxkm
tags:
  - java
  - clean code
  - refactoring
  - records
  - lombok
categories:
  - Research
  - Guide
---

Java Record vs. Lombok @Data: A Comparative Analysis of Data Handling Approaches

![](https://cdn-images-1.medium.com/max/2000/1*81kca6g59ZnJJET0mKy4NQ.jpeg)

When working with Java records and Lombok’s @Data annotation, both provide a way to create immutable data classes with minimal boilerplate. However, they have different use cases and implications.

All examples we will review on well known class Person. Here is the example of using it like vanilla POJO.

    public class Person {
        private final int id;
        private final String name;
    
        public int getId() {
            return id;
        }
    
        public String getName() {
            return name;
        }
    
        public Person(int id, String name) {
            this.id = id;
            this.name = name;
        }
    
        @Override
        public String toString() {
            return "Person{id=" + id + ", name='" + name + '\'' + '}';
        }
    
        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            Person person = (Person) o;
            return id == person.id && Objects.equals(name, person.name);
        }
    
        @Override
        public int hashCode() {
            return Objects.hash(id, name);
        }
    }

## Java Records

Introduced in Java 14 as a preview feature and standardized in Java 16, records are a special kind of class that is designed to be a simple, immutable data carrier.

    public record Person(String name, int age) {
    }

Even Lombok annotations [@Data](http://twitter.com/Data) and [@Value](http://twitter.com/Value) annotations have provided similar functionality for a long time, albeit with a little more lines:

    @Data
    class Person {
      private final int id;
      private final Stirng name;
    }

Reducing boilerplate code is a consequence, not the primary purpose, of Java records. This important distinction is often overlooked, with much focus on the obvious and demonstrable reduction in boilerplate. The official documentation emphasizes this angle, while [JEP 395](https://openjdk.org/jeps/395), though more detailed on semantics, is vague about the benefits of records. This article aims to clarify those benefits.

Records are classes designed to transparently carry immutable data, signaling this intent to the compiler and others. This basic semantics implies storing immutable data with transparent access. If these semantics don’t fit your use case, avoid using records, as misusing them can harm your architecture. They’re not equivalent to **@Data** or **@Value **annotations for data classes.

### Key Features of Records:

1. **Conciseness**: Records require less boilerplate code compared to regular classes.

2. **Immutability**: Fields in records are final by default, making records immutable.

3. **Automatic Method Generation**: Records automatically generate **equals(), hashCode(), toString()**, and accessor methods.

4. **Canonical Constructor**: Records come with a canonical constructor that takes all fields as parameters.

5. **Compact Syntax**: Defined using the **record **keyword.

### Validation logic to a record’s constructor:

Here, the canonical constructor is implicitly declared, and you can use it to enforce constraints like ensuring the lower bound (lo) is not greater than the upper bound (hi). Here is your example for clarity:

    public record Range(int lo, int hi) {
        public Range {
            if (lo > hi) {
                throw new IllegalArgumentException(String.format("(%d,%d)", lo, hi));
            }
        }
    }

### Defining more complex constructor:

    record Rational(int num, int denom) {
        Rational(int num, int demon) {
            int gcd = gcd(num, denom);
            num /= gcd;
            denom /= gcd;
            this.num = num;
            this.denom = denom;
        }
    }
    
    private static int gcd(int a, int b) {
        while (b != 0) {
            int temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }

Records are transparent carriers of immutable data.

To summarize:

* Accessors (getter methods) are generated by the compiler and cannot have their names or return types changed.

* Overriding accessors should be done with caution.

* The compiler generates a canonical constructor.

* Records do not support inheritance.

The main benefit of records is that they enable instances to be parsed and re-instantiated in a structured manner without losing information, thanks to the combination of accessors and the canonical constructor.

## Lombok’s @Data Annotation

Lombok is a popular Java library that reduces boilerplate code by generating code at compile-time using annotations.

### Key Features of [@Data](http://twitter.com/Data):

1. **Boilerplate Reduction**: Automatically generates **getter **and **setter** methods for all fields.

2. **Other Methods**: Generates **equals()**, **hashCode()**, **toString()**, and a constructor with all fields.

3. **Optional Immutability**: Fields are not final by default, but can be made final for immutability.

4. **Java Class**: Works with standard Java classes, providing more flexibility in class design.

5. **Additional Annotations**: Works with other Lombok annotations like @**Builder**, @**AllArgsConstructor**, etc.

## Comparison

**Boilerplate Code**:

* **Records**: Minimal boilerplate, less code.

* **Lombok @Data**: Reduced boilerplate, but still more code compared to records.

**Immutability**:

* **Records**: Immutable by default.

* **Lombok @Data**: Not immutable by default, but can be made immutable with **final **fields.

**Use Case**:

* **Records**: Ideal for simple, immutable data carriers with a fixed set of fields.

* **Lombok @Data**: More flexible, suitable for cases where immutability is not required or for complex class structures.

**Method Generation**:

* **Records**: Automatically generates methods for **equals()**, **hashCode()**, **toString()**, and accessors.

* **Lombok @Data**: Generates **getter**, **setter**, **equals()**, **hashCode()**, **toString()**, and **constructors**.

**Performance**:

* **Records**: Potentially better performance due to optimizations in the JVM for records.

* **Lombok @Data**: May have some overhead due to runtime annotation processing.

## Conclusion

* **Use Java Records** if you are using Java 16 or later and need a simple, immutable data carrier with a fixed set of fields.

* **Use Lombok @Data** if you need the flexibility of standard Java classes, possibly need mutable fields, or are using a version of Java earlier than 16.

### Disadvantages of records

Drawbacks of records include their limited flexibility compared to regular classes. With records, you can’t introduce hidden state by adding fields, modify accessors’ names or return types, or alter the values they return. Furthermore, since record fields are final, their values cannot be changed. Additionally, records do not support class inheritance, although interfaces can still be implemented. If you require any of these features, using a regular class instead of a record is advisable, even if only a small portion of the functionality differs, as the majority of the boilerplate will still be present.

### Lombok Advantages

Benefits of Lombok’s [**@Data](http://twitter.com/Data)** and [**@Value](http://twitter.com/Value)** annotations lie in their code generation capabilities. These annotations offer flexibility, allowing you to freely modify the class without being constrained by predefined semantics. However, this flexibility comes at the cost of stricter guarantees that traditional Java constructs provide. While Lombok may potentially introduce additional features like destructuring methods in the future, it’s worth noting that heavy reliance on internal compiler APIs poses a risk, as changes in these APIs could break projects using Lombok. Concealing technical debt from users is also not advisable.

Choosing between the two depends on your specific needs and the version of Java you are using. Records provide a more modern and concise approach to immutable data classes, while Lombok offers greater flexibility and compatibility with older Java versions.