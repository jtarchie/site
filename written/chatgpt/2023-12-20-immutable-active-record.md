---
title: Immutable ActiveRecord with History
source: https://chat.openai.com/c/c8dc7897-ebdf-4deb-acf6-44e89416a886
---

# Immutable ActiveRecord with History

#### You:

I want to write some code that makes allows an ActiveRecord to be created, but
not updated. I want to ensure that I am writing immutable data structures with
ActiveRecord.

For example,

Given a migration:

create_table :posts do |t| t.string :title t.text :content t.timestamps end

Given a model:

class Post < ApplicationRecord; end

I want to change the schema and code to be able to do two things:

- Ensure a record cannot be updated and raise an error
- Be able to create a new instance of an object, so that the history can be
  followed. For example, if I change description, it would create a new instance
  of `Post` with the same title as its original, just with the update
  description. And have reference to its original.
- Scopes and helper methods that allow me to access the history of a Post over
  its lifetime and get the latest version of one. Please provide the migrations
  needed with appropriate indexes.

#### ChatGPT:

To achieve immutable ActiveRecord objects in Ruby on Rails, where updates create
new records while preserving the history of changes, you need to modify your
`Post` model and database schema. Here’s a step-by-step guide to implement this:

1. **Modify the Schema**: First, we'll modify the `posts` table to include a
   reference to the previous version of the post. This will be used to track the
   history of each post. We also need an index to efficiently query the latest
   version of a post.

   **Migration**:

   ```ruby
   class AddPreviousPostIdToPosts < ActiveRecord::Migration[6.0]
     def change
       add_reference :posts, :previous_post, foreign_key: { to_table: :posts }
       add_index :posts, [:id, :previous_post_id], unique: true
     end
   end
   ```

2. **Update the Model**: Override the `update` and `save` methods in the `Post`
   model to ensure immutability. When an update is attempted, create a new
   `Post` instance with the new attributes and link it to the original post.

   **Model**:

   ```ruby
   class Post < ApplicationRecord
     has_one :next_post, class_name: 'Post', foreign_key: :previous_post_id

     def update(attributes)
       raise ActiveRecord::ReadOnlyRecord, 'Post is immutable'
     end

     def save(*args)
       if persisted?
         raise ActiveRecord::ReadOnlyRecord, 'Post is immutable'
       else
         super
       end
     end

     def immutable_update(attributes)
       Post.create!(attributes.merge(previous_post_id: self.id))
     end
   end
   ```

3. **Scopes and Helper Methods**: To access the history and the latest version
   of a post, you can define scopes and methods in the `Post` model.

   **Additions to the Model**:

   ```ruby
   class Post < ApplicationRecord
     # ... [previous code] ...

     # Scope to get the original posts
     scope :original_posts, -> { where(previous_post_id: nil) }

     # Scope to get the latest version of each post
     scope :latest_versions, -> { 
       original_posts.left_joins(:next_post)
                     .where(next_posts_posts: { id: nil })
     }

     # Get the entire history of a post
     def history
       [self, *previous_posts].compact
     end

     private

     def previous_posts
       prev_post = previous_post
       posts = []
       while prev_post
         posts << prev_post
         prev_post = prev_post.previous_post
       end
       posts
     end
   end
   ```

With these changes, you can create a new `Post`, and any attempt to update it
will result in a new `Post` being created with a reference to its predecessor.
You can trace the history of any `Post` and easily fetch the latest version of
each post. This setup ensures data immutability while allowing the tracking of
changes over time.

#### You:

Will the scope `latest_versions` return all the latest versions or just the
single latest version?

#### ChatGPT:

The `latest_versions` scope in the provided code will return all the latest
versions of each post, not just a single latest version. It works by finding all
original posts (those without a `previous_post_id`) that do not have a
subsequent version (i.e., they are not referenced as a `previous_post` by any
other post).

This scope effectively filters out all the posts that have been updated (and
therefore have a newer version) and returns only those posts that are the most
recent in their respective update chains. This means if you have multiple posts,
each possibly with several updated versions, this scope will return the latest
version of each individual post.

Here's a breakdown of how the scope works:

- `original_posts`: Filters the posts to include only those that are the
  starting point of their update chains (i.e., they have no previous post).

- `left_joins(:next_post)`: Performs a left join with the `posts` table on
  itself, linking each original post to its next version, if it exists.

- `where(next_posts_posts: { id: nil })`: Filters the result of the join to
  include only those rows where the next post does not exist. This condition is
  met by posts that are the latest version in their update chain.

Using this scope, you'll get a collection of posts, each being the latest
version of its update chain.
