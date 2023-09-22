# Interview Questions

## Introduction

- Software Engineering 17+ years
- Generalist
- Different domains, approach is technology isn't the challenging part, its
  translating the business domain to solveable problems, that use technology

## Behavioral Questions

- You took someone's engineering vision and brought it to life?
- Have you ever had to navigate a situation where you disagreed with a colleague
  or team member on a technical decision or project direction? How did you
  handle the conflict, and what was the outcome?

  > Thank you for the question. I recall a project where my team and I built an
  ETL tool for a client with two decades of unstructured data. Our goal was to
  structure this data for clarity and consistency. Using Rails and Active Admin,
  we quickly set up a relational database solution that worked smoothly. It
  allowed the client's data specialist to efficiently categorize records, like
  distinguishing between wedding gowns and bridesmaid dresses.

  > However, a challenge arose when one of their lead engineers recommended
  transitioning to MongoDB, believing it would handle the data load better.
  However, we needed metrics suggesting this was necessary. We advised against
  this switch, understanding the strengths of relational databases for our data
  structuring.

  > Regrettably, the decision was made to switch. Over the next three weeks, we
  restructured the backend for MongoDB. This led to complications as we lost
  many previous functionalities with the Rails tools. Even the end user found
  the new system more tedious, and some of the database queries timed out due to
  the nature of MongoDB's document-based structure.

  > To resolve the issues, the client brought in consultants from Atlas, a company
  specializing in MongoDB. These consultants confirmed that while our
  implementation of MongoDB was correct, there needed to be a better tool for
  our objectives.

  > This experience taught me a valuable lesson: sometimes, even when you provide
  a clear rationale against a decision, it may still be overridden for various
  reasons. The key is adapting, persevering, and prioritizing the product's
  functionality over personal or collective preferences. Ultimately, we must
  engineer for the product's best outcome.
- Technology evolves rapidly. How do you stay up-to-date with industry trends
  and new technologies, and how have you applied this knowledge to improve your
  work or team's processes?

  > Staying updated with the ever-evolving technology landscape is imperative. To
  do so, I've often approached learning new technologies with a unique method:
  reverse engineering. Let me share an example to illustrate.

  > I have always been drawn to understanding the core of technologies. So, when I
  wanted to learn Lua, instead of starting with conventional tutorials, I took a
  project I was familiar with, underscore.js. I aimed to reimplement its
  functions in Lua. I began by examining a function in underscore.js, looked at
  its test cases, and then tried translating them to Lua and implementing the
  function. While this approach doesn't necessarily explain the rationale behind
  the original developer's choices, it lets me grasp the "shape" or the core
  structure of the technology. This deep dive helps me discern if issues arise
  due to genuine bugs or misuse on my part.

  > Diving into the code, breaking it apart, and trying to piece it together in a
  different environment provides profound insights. While I focus predominantly
  on code, the same principle applies across various domains, databases, or AI
  tools. Tutorials might offer a glimpse of a tool's potential, but to truly
  understand its depth, breaking it apart and exploring its foundations is the
  way to go.

  > Moreover, I always encourage my team to adopt a similar hands-on approach.
  When a teammate grapples with a technological challenge, I often suggest
  pairing up. But instead of directing, I prompt them with questions, allowing
  them to navigate and understand the tool themselves. It's a method of guiding
  without imposing, allowing them to develop an intuitive understanding, which
  I've found far more effective than spoon-feeding solutions.

- What is the most technically challenging?

  > During interviews, I'm often asked about the most technically challenging
  problem I've tackled. Instead of viewing these challenges as singular large
  problems, I perceive them as a series of smaller issues. Tackling them in
  steps prevents feeling overwhelmed. My problem-solving approach involves
  measuring, evaluating, and iterating – a methodology I believe I've
  internalized from agile practices.

  > For instance, while working at Realtor.com, I observed numerous 500 errors in
  an inherited application. These errors adversely affected users, often
  preventing them from logging in or completing specific actions. Built on AWS,
  I was confident that the platform provided metrics to understand the issue
  better.

  > During a significant error event, I delved into our load balancer's metrics
  dashboard. I observed that connection timeouts predominantly caused these 500
  errors, and not just bad gateway responses. As an initial solution, I modified
  the scaling rules to allocate more application instances. This strategy
  decreased the frequency of errors, but they continued to occur.

  > Further investigation during the next error event revealed that every
  significant error event correlated with a scaling event – either scaling up or
  down based on the number of Virtual Machine (VM) instances running. To rectify
  this, I adjusted the VM scaling to be less aggressive. This meant scaling down
  one VM over a more extended period and scaling up more aggressively. The
  number of 500 errors did drop, but they didn't completely vanish.

  > By drilling down even further into our metrics, I noticed an anomaly during VM
  scaling down events. A large number of our application's containers were being
  stopped and restarted. I discovered that AWS's ECS, their container management
  service, had an aggressive algorithm aiming to reduce the number of VMs and
  save costs. This algorithm introduced a bug where, during scaling down, it
  would attempt to reshuffle and restart containers to fit them into fewer VMs.
  This led to temporary 500 errors, as the load balancer wasn't appropriately
  informed about these restarts.

  > After additional fine-tuning, we reduced these errors from hundreds of
  thousands within specific time frames to a few hundred per week. As a bonus,
  optimizing our scaling rules and understanding our application better led to
  monthly savings of around $10,000. This challenge was not just about fixing an
  error, but also about understanding the system holistically and finding
  cost-saving efficiencies in the process.

- Reflect on a mistake or failure in your career. What did you learn from it,
  and how did you use that experience to improve your skills and decision-making
  in subsequent projects?

  > One of the most challenging aspects of my career has been effective
  communication. A common stereotype associated with individuals like myself is
  a lack of social skills. There were instances when I conveyed something, but
  the tone in which it was received wasn't the one I intended. This
  misinterpretation often led to misunderstandings, with people thinking I had
  said something offensive. These moments were misreadings of my intention
  rather than an actual lack of empathy on my part.

  > One particular challenge I faced was ensuring that my tone in written
  communications accurately reflected my intentions. I wanted my messages to be
  direct but also empathetic. To improve this, I sought guidance from mentors
  known for their excellent communication skills. They provided invaluable
  feedback, teaching me techniques like writing a message, stepping away for a
  few minutes, and then revisiting it to ensure clarity and empathy. This
  approach helped immensely.

  > Additionally, I made use of tools like Grammarly's premium package to refine
  my writing. It helped in identifying words that might come across as
  aggressive or unintentionally rude. Moreover, it rectified some of my
  persistent grammatical errors, like often omitting words because I believed I
  had already typed them.

  > Beyond tools, I invested in my communication skills by reading books on the
  subject. One influential read was on nonviolent communication. Although my
  messages were never aggressive, the principles of this methodology helped me
  frame my communication more effectively, ensuring that my tone was always
  clear and friendly.

  > In summary, my journey has been about learning to articulate my thoughts
  clearly while also being empathetic and considerate of the reader's
  perspective. This understanding has been instrumental in both my personal and
  professional growth.

- Can you describe a challenging situation involving a team or group of people
  that you helped resolve?

  > Certainly! One of the most challenging situations I faced was when my team was
  tasked with phasing out a product that many in the company had come to rely
  upon, even though it was problematic. The product had grown organically over
  time and was riddled with issues, such as a thousand-line YAML configuration
  file that made it very challenging to use. Although it was problematic, many
  users, both internal and external, were hesitant to let go because it was the
  only solution available at the time.

  > Our primary goal was to transition users to a newer, more effective product.
  The first step was to establish trust. We initiated dialogues with our
  customers, typically involving our design, product, and engineering teams, in
  what were essentially trust-building sessions. These weren’t just user
  interviews; they were genuine conversations to assure users that we were
  invested in their needs and were actively working on a more robust solution.

  > Interestingly, the trust-building process wasn’t just external. Internally,
  there had been a longstanding tension between the support side of our
  organization and R&D. The support team had attempted in the past to get R&D's
  assistance on the older product but felt neglected. There was a lot of
  historical baggage to address.

  > Once we built those relationships and trust, we outlined our plan: sunsetting
  the old product while ensuring a smooth transition to the new one. We set
  clear boundaries – we wouldn't support the older product unless there was a
  top-priority issue that directly hindered someone’s work. To ensure our new
  product met user needs, we incorporated feedback from both an external
  customer and an internal user into our MVP development process. This approach
  not only made the product better but also further ingrained the trust we had
  been building.

  > The result? After a period of persistent trust-building, collaboration, and
  clear communication, we successfully transitioned users to the new product.
  Today, the product is not only stable and efficient, but the support issues
  have also significantly decreased. This journey underscored the importance of
  trust, understanding, and consistent communication in overcoming
  organizational challenges.
