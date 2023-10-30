---
title: Java Code Writing
source: https://chat.openai.com/c/a8fc4a42-0581-4b58-a85b-5697cc27c368
---

# Java Code Writing

#### You:

Let's write a program in Java. I'm going to introduce code via psuedo-code
tests, then please write the necessary, but minimal code to make those tests
pass. Alright?

#### ChatGPT:

Absolutely! Please provide the pseudocode tests, and I'll help you write the
Java code to make them pass.

#### You:

Set set = new Set(); assert(set.isEmpty(), true)

#### ChatGPT:

Alright, based on the pseudocode test you've provided, you want to create a
`Set` class that has a method `isEmpty()` which returns `true` when the set is
empty.

Here's the minimal Java code to make that test pass:

```java
public class Set {
    private int size = 0;

    public boolean isEmpty() {
        return size == 0;
    }
}

// Test
public class TestSet {
    public static void main(String[] args) {
        Set set = new Set();
        assert set.isEmpty() : "Set should be empty";
        System.out.println("Test passed!");
    }
}
```

You can run the `TestSet` class to see if the test passes. If there's no
assertion error, it means the test passed successfully.

#### You:

Great, next test.

Set set = new Set(); set.add(1); assert(set.isEmpty(), false)

#### ChatGPT:

Alright, now you want to add an `add` method to the `Set` class that allows you
to add an integer to the set. After adding an integer, the set should no longer
be empty.

Here's the updated Java code to make that test pass:

```java
import java.util.HashSet;

public class Set {
    private HashSet<Integer> data = new HashSet<>();

    public void add(int value) {
        data.add(value);
    }

    public boolean isEmpty() {
        return data.isEmpty();
    }
}

// Test
public class TestSet {
    public static void main(String[] args) {
        // First test
        Set set1 = new Set();
        assert set1.isEmpty() : "Set should be empty";

        // Second test
        Set set2 = new Set();
        set2.add(1);
        assert !set2.isEmpty() : "Set should not be empty after adding an element";

        System.out.println("All tests passed!");
    }
}
```

Both tests are included in the `TestSet` class. Running it should pass both
tests.

#### You:

That is incorrect. I said do the simplest things possible. So far we don't need
to use any complex data structures like HashSet. What is a simpler way of making
the tests pass so far?

#### ChatGPT:

I apologize for the oversight. You're right; based on the tests provided so far,
we can use a simpler approach.

Here's a more minimalistic version:

```java
public class Set {
    private boolean hasElement = false;

    public void add(int value) {
        hasElement = true;
    }

    public boolean isEmpty() {
        return !hasElement;
    }
}

// Test
public class TestSet {
    public static void main(String[] args) {
        // First test
        Set set1 = new Set();
        assert set1.isEmpty() : "Set should be empty";

        // Second test
        Set set2 = new Set();
        set2.add(1);
        assert !set2.isEmpty() : "Set should not be empty after adding an element";

        System.out.println("All tests passed!");
    }
}
```

This version uses a simple boolean flag to track if an element has been added to
the set.

#### You:

That's great. Lets work on a new test for a new function. We are going see if we
can find the length of the set. So reusing the tests from above.

Set set = new Set(); assert(set.length(), 0)

#### ChatGPT:

Alright, you want to add a `length` method to the `Set` class that returns the
number of elements in the set. Given the tests so far, we can use an integer to
keep track of the count of elements.

Here's the updated Java code to make the new test pass:

```java
public class Set {
    private boolean hasElement = false;
    private int count = 0;

    public void add(int value) {
        if (!hasElement) {
            hasElement = true;
            count++;
        }
    }

    public boolean isEmpty() {
        return !hasElement;
    }

    public int length() {
        return count;
    }
}

// Test
public class TestSet {
    public static void main(String[] args) {
        // First test
        Set set1 = new Set();
        assert set1.isEmpty() : "Set should be empty";

        // Second test
        Set set2 = new Set();
        set2.add(1);
        assert !set2.isEmpty() : "Set should not be empty after adding an element";

        // Third test
        Set set3 = new Set();
        assert set3.length() == 0 : "Set should have a length of 0";

        System.out.println("All tests passed!");
    }
}
```

The `length` method now returns the count of elements in the set.

#### You:

What's another test we could write to ensure we are testing length for other
conditions?

#### ChatGPT:

To ensure the `length` method works correctly for various conditions, we can
test the following scenarios:

1. **Adding multiple unique elements**: This will test if the length increases
   appropriately when new unique elements are added.

   ```java
   Set set = new Set();
   set.add(1);
   set.add(2);
   assert(set.length() == 2) : "Set should have a length of 2 after adding two unique elements";
   ```

2. **Adding duplicate elements**: This will test if the length remains unchanged
   when a duplicate element is added.

   ```java
   Set set = new Set();
   set.add(1);
   set.add(1);
   assert(set.length() == 1) : "Set should have a length of 1 after adding a duplicate element";
   ```

3. **Removing an element**: If we introduce a `remove` method later, we can test
   if the length decreases appropriately.

   ```java
   Set set = new Set();
   set.add(1);
   set.add(2);
   set.remove(1);
   assert(set.length() == 1) : "Set should have a length of 1 after removing an element";
   ```

4. **Clearing the set**: If we introduce a `clear` method later, we can test if
   the length becomes zero after clearing the set.

   ```java
   Set set = new Set();
   set.add(1);
   set.add(2);
   set.clear();
   assert(set.length() == 0) : "Set should have a length of 0 after clearing";
   ```

These tests will help ensure that the `length` method behaves correctly across
various scenarios.

#### You:

Alright using the first test, how can we implement in you Set class so far?

#### ChatGPT:

To implement the first test, we need to modify the `Set` class to handle
multiple unique elements. We can use a simple list to store the elements and
ensure that duplicates are not added.

Here's the updated `Set` class and the test:

```java
import java.util.ArrayList;

public class Set {
    private ArrayList<Integer> elements = new ArrayList<>();

    public void add(int value) {
        if (!elements.contains(value)) {
            elements.add(value);
        }
    }

    public boolean isEmpty() {
        return elements.isEmpty();
    }

    public int length() {
        return elements.size();
    }
}

// Test
public class TestSet {
    public static void main(String[] args) {
        // First test
        Set set1 = new Set();
        assert set1.isEmpty() : "Set should be empty";

        // Second test
        Set set2 = new Set();
        set2.add(1);
        assert !set2.isEmpty() : "Set should not be empty after adding an element";

        // Third test
        Set set3 = new Set();
        assert set3.length() == 0 : "Set should have a length of 0";

        // Fourth test
        Set set4 = new Set();
        set4.add(1);
        set4.add(2);
        assert set4.length() == 2 : "Set should have a length of 2 after adding two unique elements";

        System.out.println("All tests passed!");
    }
}
```

The `add` method now checks if the element is already in the set before adding
it. The `length` method returns the size of the `elements` list.

#### You:

This is using a data structure ArrayList which we don't have available. What is
the simplest thing we can do?

#### ChatGPT:

I apologize for the oversight. Let's simplify further.

Given the constraints, we can use an array to store the elements. We'll also
need to manually check for duplicates and resize the array when necessary.

Here's a simple implementation using an array:

```java
public class Set {
    private int[] elements = new int[10];  // Initial capacity
    private int size = 0;

    public void add(int value) {
        if (!contains(value)) {
            if (size == elements.length) {
                resize();
            }
            elements[size++] = value;
        }
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public int length() {
        return size;
    }

    private boolean contains(int value) {
        for (int i = 0; i < size; i++) {
            if (elements[i] == value) {
                return true;
            }
        }
        return false;
    }

    private void resize() {
        int[] newElements = new int[size * 2];
        System.arraycopy(elements, 0, newElements, 0, size);
        elements = newElements;
    }
}

// Test
public class TestSet {
    public static void main(String[] args) {
        // First test
        Set set1 = new Set();
        assert set1.isEmpty() : "Set should be empty";

        // Second test
        Set set2 = new Set();
        set2.add(1);
        assert !set2.isEmpty() : "Set should not be empty after adding an element";

        // Third test
        Set set3 = new Set();
        assert set3.length() == 0 : "Set should have a length of 0";

        // Fourth test
        Set set4 = new Set();
        set4.add(1);
        set4.add(2);
        assert set4.length() == 2 : "Set should have a length of 2 after adding two unique elements";

        System.out.println("All tests passed!");
    }
}
```

This implementation uses a dynamic array approach. The `resize` method doubles
the array size when it's full.

#### You:

We haven't written test coverage for a contains function yet. Can you just write
an implementation that covers the two functions we have test coverage for at the
moment, isEmpty and length?

#### ChatGPT:

Certainly! I'll simplify the implementation to cover just the `isEmpty` and
`length` functions based on the tests provided.

Here's a basic implementation using a simple array and a counter:

```java
public class Set {
    private int[] elements = new int[10];  // Initial capacity
    private int size = 0;

    public void add(int value) {
        for (int i = 0; i < size; i++) {
            if (elements[i] == value) {
                return;  // Element already exists, so we don't add it again
            }
        }
        if (size == elements.length) {
            // Resize the array if necessary (for now, we'll just double its size)
            int[] newElements = new int[size * 2];
            System.arraycopy(elements, 0, newElements, 0, size);
            elements = newElements;
        }
        elements[size++] = value;
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public int length() {
        return size;
    }
}

// Test
public class TestSet {
    public static void main(String[] args) {
        // First test
        Set set1 = new Set();
        assert set1.isEmpty() : "Set should be empty";

        // Second test
        Set set2 = new Set();
        set2.add(1);
        assert !set2.isEmpty() : "Set should not be empty after adding an element";

        // Third test
        Set set3 = new Set();
        assert set3.length() == 0 : "Set should have a length of 0";

        // Fourth test
        Set set4 = new Set();
        set4.add(1);
        set4.add(2);
        assert set4.length() == 2 : "Set should have a length of 2 after adding two unique elements";

        System.out.println("All tests passed!");
    }
}
```

This implementation uses a simple array and a counter (`size`) to track the
number of elements in the set. The `add` method checks for duplicates and only
adds unique elements.

#### You:

Do we need to keep track of elements yet? This could be simpler.

#### ChatGPT:

You're right. Based on the tests provided so far, we only need to track the
number of elements added, not the actual elements themselves. Let's simplify
further:

```java
public class Set {
    private int size = 0;

    public void add(int value) {
        size++;
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public int length() {
        return size;
    }
}

// Test
public class TestSet {
    public static void main(String[] args) {
        // First test
        Set set1 = new Set();
        assert set1.isEmpty() : "Set should be empty";

        // Second test
        Set set2 = new Set();
        set2.add(1);
        assert !set2.isEmpty() : "Set should not be empty after adding an element";

        // Third test
        Set set3 = new Set();
        assert set3.length() == 0 : "Set should have a length of 0";

        // Fourth test
        Set set4 = new Set();
        set4.add(1);
        set4.add(2);
        assert set4.length() == 2 : "Set should have a length of 2 after adding two unique elements";

        System.out.println("All tests passed!");
    }
}
```

This is the simplest implementation based on the tests provided. The `add`
method just increments the size, and we don't track the actual elements.

#### You:

That was a great refactor! Let's write our next test for contains,

Set set = new Set() assert(set.contains("A"), false)

set.add("B") assert(set.contains("B"), true) assert(set.contains("A"), false)

#### ChatGPT:

Great! Now, we're introducing the `contains` method and changing the type of
elements in the set to `String` instead of `int`.

Here's the updated `Set` class and the new test:

```java
public class Set {
    private String[] elements = new String[10];  // Initial capacity
    private int size = 0;

    public void add(String value) {
        if (!contains(value)) {
            if (size == elements.length) {
                // Resize the array if necessary
                String[] newElements = new String[size * 2];
                System.arraycopy(elements, 0, newElements, 0, size);
                elements = newElements;
            }
            elements[size++] = value;
        }
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public int length() {
        return size;
    }

    public boolean contains(String value) {
        for (int i = 0; i < size; i++) {
            if (elements[i].equals(value)) {
                return true;
            }
        }
        return false;
    }
}

// Test
public class TestSet {
    public static void main(String[] args) {
        // Previous tests
        Set set1 = new Set();
        assert set1.isEmpty() : "Set should be empty";

        Set set2 = new Set();
        set2.add("A");
        assert !set2.isEmpty() : "Set should not be empty after adding an element";

        Set set3 = new Set();
        assert set3.length() == 0 : "Set should have a length of 0";

        Set set4 = new Set();
        set4.add("A");
        set4.add("B");
        assert set4.length() == 2 : "Set should have a length of 2 after adding two unique elements";

        // New tests for contains
        Set set5 = new Set();
        assert !set5.contains("A") : "Set should not contain 'A'";

        set5.add("B");
        assert set5.contains("B") : "Set should contain 'B' after adding it";
        assert !set5.contains("A") : "Set should not contain 'A'";

        System.out.println("All tests passed!");
    }
}
```

The `contains` method checks if a given string value is present in the set. The
`add` method has been updated to handle strings and ensure no duplicates are
added.
