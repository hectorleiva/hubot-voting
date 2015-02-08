# hubot-voting

To vote on topics

See [`src/hubot-voting.coffee`](src/hubot-voting.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-voting --save`

Then add **hubot-voting** to your `external-scripts.json`:

```json
["hubot-voting"]
```

## Sample Interaction

### Start a vote

    `hubot start vote first item, second item, third item`

### Vote

    `hubot vote for first item`

or...

    `hubot vote for 1`

or...

    `hubot vote first item`

or...

    `hubot vote 1`

### Show choices

    `hubot show choices`

### Show votes

    `hubot show votes`

### End a vote

    `hubot end vote`

## License

MIT licensed. Copyight 2014 Joshua Antonishen + 2015 Hector Leiva
