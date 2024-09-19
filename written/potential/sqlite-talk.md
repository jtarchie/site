I'm working on a blog post and a corresponding short talk. I'm gearing them to be practical examples of constraint-driven development (or what I believe it to be).

The idea is that you start with constraints with your system—think limited resources and costs—while still maintaining a usable product. The best example we can all relate to is Doom. The program is single-threaded and did tricks with [inverse square root](https://en.wikipedia.org/wiki/Fast_inverse_square_root), [random number](https://www.reddit.com/r/ProgrammerHumor/comments/3bhvuj/how_random_numbers_are_generated_in_classic_doom/), etc.

My personal example is a full-text search against every English Wikipedia article, which could (hopefully) run on your phone.

I know numbers would be helpful (in order) working towards the constraint:
1. 22GiB [XML](https://meta.wikimedia.org/wiki/Data_dumps/Dump_format) bz2 file
2. 98GB Sqlite with FTS5 index (1h30m to build)
3. with different `detail` for FTS5 (with 20 quantity compression via [sqlite-zstd](https://github.com/jtarchie/sqlitezstd/))
   - `detail=none`: 28Gib (does not allow search through title or column, considered one field)
   - `detail=column`: 33Gib allows searching columns but not phrases like `Disney World`. You'd search for each term `Disney` and `World`.
   - `detail=full`: 40Gib allows for phrases like`Disney World`.
4. What does this mean for querying speed?
   - 

4. with different compression quantities with `detail=column`
   - 20 quantity: 33 Gib taking 1h20m
   - 1 quantity: 37 Gib taking 12m