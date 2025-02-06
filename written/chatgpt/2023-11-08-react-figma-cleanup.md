---
title: React Component Tailwind Transformation
---

# React Component Tailwind Transformation

#### You:

I have a React component that uses a reducer hook to manage state changes for
styles, which includes hover, active, and focus states. I want to refactor the
code to use Tailwind's pseudo-classes instead of JavaScript states to handle
these style changes. Here is a 'before' example where JavaScript states are used
to manage styles:

```jsx
import React from "react";
import { useReducer } from "react";

export const Button = ({ property1, className, text = "Sigh up" }) => {
  const [state, dispatch] = useReducer(reducer, {
    property1: property1 || "noactive",
  });

  return (
    <div
      className={`flex items-center px-[40px] py-[22px] relative w-[300px] rounded-[20px] gap-[10px] justify-center ${
        state.property1 === "stroke" ? "border-transparent" : ""
      } ${
        ["active", "hover", "press"].includes(state.property1)
          ? "shadow-shadow-button"
          : ""
      } ${
        state.property1 === "noactive"
          ? "[background:linear-gradient(180deg,rgb(238,241.38,255)_0%,rgb(217.65,229.56,247.56)_100%)]"
          : state.property1 === "active"
          ? "[background:linear-gradient(180deg,rgb(53,84,209)_0%,rgb(43,127,254)_100%)]"
          : state.property1 === "hover"
          ? "[background:linear-gradient(180deg,rgb(71.72,103.07,229.5)_0%,rgb(43,127,254)_100%)]"
          : state.property1 === "press"
          ? "[background:linear-gradient(180deg,rgb(53,84,209)_0%,rgb(21.8,96.45,209.31)_100%)]"
          : ""
      } ${
        state.property1 === "stroke"
          ? "[border-image:linear-gradient(to_bottom,rgb(53,84,209),rgb(43,127,254))_1]"
          : ""
      } ${
        state.property1 === "stroke" ? "border border-solid" : ""
      } ${className}`}
      onMouseEnter={() => {
        dispatch("mouse_enter");
      }}
      onMouseLeave={() => {
        dispatch("mouse_leave");
      }}
    >
      <div
        className={`font-text-bold-16px w-fit mt-[-1.00px] tracking-[var(--text-bold-16px-letter-spacing)] text-[length:var(--text-bold-16px-font-size)] [font-style:var(--text-bold-16px-font-style)] relative font-[number:var(--text-bold-16px-font-weight)] whitespace-nowrap leading-[var(--text-bold-16px-line-height)] ${
          state.property1 === "noactive"
            ? "text-gray-300"
            : state.property1 === "stroke"
            ? "text-blue-50-0active"
            : "text-white"
        }`}
      >
        {text}
      </div>
    </div>
  );
};

function reducer(state, action) {
  if (state.property1 === "hover") {
    switch (action) {
      case "mouse_leave":
        return {
          property1: "active",
        };
    }
  }

  switch (action) {
    case "mouse_enter":
      return {
        ...state,
        property1: "hover",
      };
  }

  return state;
}
```

And here is the 'after' example where Tailwind's pseudo-classes are used:

```jsx
export const Button = ({ className, text, handler }) => {
  return (
    <button
      className={`
        flex items-center px-[40px] py-[22px] relative w-[300px] rounded-[20px] gap-[10px] justify-center
        border border-transparent border-solid
        shadow-shadow-button
        hover:shadow-none
        [background:linear-gradient(180deg,rgb(53,84,209)_0%,rgb(43,127,254)_100%)]
        hover:[background:linear-gradient(180deg,rgb(71.72,103.07,229.5)_0%,rgb(43,127,254)_100%)]
        !bg-[rgba(255,255,255,1.0)]
        ${className}`}
      onClick={handler}
    >
      <span
        className={`font-text-bold-16px w-fit mt-[-1.00px] tracking-[var(--text-bold-16px-letter-spacing)] text-[length:var(--text-bold-16px-font-size)] [font-style:var(--text-bold-16px-font-style)] relative font-[number:var(--text-bold-16px-font-weight)] whitespace-nowrap leading-[var(--text-bold-16px-line-height)] text-white`}
      >
        {text}
      </span>
    </button>
  );
};
```

I would like to apply this transformation to other similar components. Can you
help me create a general set of rules or a script that will automate this
process?"

---

When you are providing this to a developer or a script for automation, make sure
to highlight the specific changes like:

1. Removal of `useReducer` and `state` management for styles.
2. Replacement of conditional class assignments with Tailwind pseudo-classes
   like `hover:`, `active:`, etc.
3. Simplification of the className string to directly include Tailwind styles
   instead of using JavaScript ternary operations or state checks.
4. Any additional props and PropTypes that need to be added or removed.
5. Assume that the default value for the initial reducer value was active, so
   use that the default classes don't have to have `active:` in front of them.

You will just prompt me with, "Waiting for the React component to transform."

#### ChatGPT:

Waiting for the React component to transform.

#### You:

```jsx
import PropTypes from "prop-types";
import React from "react";
import { useReducer } from "react";
import { Property1IcListing } from "../../icons/Property1IcListing";

export const ButtonIcon = ({
  property1,
  className,
  icon = (
    <Property1IcListing className="absolute! w-[24px]! h-[24px]! top-[8px]! left-[8px]!" />
  ),
}) => {
  const [state, dispatch] = useReducer(reducer, {
    property1: property1 || "active",
  });

  return (
    <div
      className={`w-[40px] h-[40px] rounded-[10px] relative ${
        state.property1 === "hover"
          ? "[background:linear-gradient(180deg,rgb(228.44,239.01,255)_0%,rgb(255,255,255)_100%)]"
          : ""
      } ${state.property1 === "hover" ? "border border-solid" : ""} ${
        state.property1 === "hover" ? "border-blue-100" : ""
      } ${state.property1 === "hover" ? "shadow-shadow-button" : ""} ${
        state.property1 === "active" ? "bg-white" : ""
      } ${className}`}
      onMouseLeave={() => {
        dispatch("mouse_leave");
      }}
      onMouseEnter={() => {
        dispatch("mouse_enter");
      }}
    >
      {icon}
    </div>
  );
};

function reducer(state, action) {
  switch (action) {
    case "mouse_enter":
      return {
        ...state,
        property1: "hover",
      };

    case "mouse_leave":
      return {
        ...state,
        property1: "active",
      };
  }

  return state;
}

ButtonIcon.propTypes = {
  property1: PropTypes.oneOf(["active", "hover"]),
};
```

#### ChatGPT:

To refactor your `ButtonIcon` component to use Tailwind's pseudo-classes instead
of JavaScript states for handling hover styles, you can follow these general
rules:

1. Remove the `useReducer` hook and `state` management for hover styles.
2. Replace conditional class assignments with Tailwind pseudo-classes like
   `hover:`.
3. Simplify the `className` string to directly include Tailwind styles instead
   of using JavaScript ternary operations or state checks.
4. Remove any unused `PropTypes` that were related to the state management
   removed.
5. For the `active` state, since it's the default, you don't have to use the
   `active:` pseudo-class in Tailwind; just include the default styles in the
   class list.

Here's how the refactored component would look after applying these rules:

```jsx
import { Property1IcListing } from "../../icons/Property1IcListing";

export const ButtonIcon = ({
  className,
  icon = (
    <Property1IcListing className="absolute! w-[24px]! h-[24px]! top-[8px]! left-[8px]!" />
  ),
}) => {
  return (
    <div
      className={`w-[40px] h-[40px] rounded-[10px] relative bg-white border border-transparent shadow-none hover:border-blue-100 hover:shadow-shadow-button hover:[background:linear-gradient(180deg,rgb(228.44,239.01,255)_0%,rgb(255,255,255)_100%)] ${className}`}
    >
      {icon}
    </div>
  );
};
```

With this transformation:

- The hover styles are now controlled by Tailwind using `hover:` prefix.
- The default state is assumed to be `active`, so default styles are applied
  without a prefix.
- The JavaScript handlers for mouse events have been removed since they are no
  longer needed.
- The `useReducer` and `state` are completely removed as Tailwind CSS is
  handling the pseudo-classes.
- The `property1` prop is removed from the component and `PropTypes` since it's
  no longer required. If you still need to handle different types or states of
  the button that can't be handled by CSS pseudo-classes (like a disabled
  state), you'll need to maintain those props and adjust the component
  accordingly.

You can apply this pattern to other similar components, but always make sure to
review each case individually as there might be unique requirements for
different components.
