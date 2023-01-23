This task doesn't have a proper `readme.md` file since this task isn't required. This file contains some notes that I would put in the full `readme.md` report.

### Setup

I'm using EC2 instances for both control node and managed nodes. There are screenshots with their IP addresses.

### Installation

Using pip, since it's the recommended way by both Ansible and community.

### Public vs private IP

At first I used public IPs to emulate setup in which the control node and managed nodes are on different edges of the Internet. At one point AWS  sent me an e-mail saying that free tier limit for data transfer is almost used up. I switched to private IPs and put all instances in one AZ since data transfer inside AZ is always free.

### Find substring in stdout

Relevant file: [playbook_loop1.yml](./l2/08_different_oss/playbook_loop1.yml)

In presentation there was the following line:

```python
until: output.stdout.find("AAA") == false
```

To highlight the issue, I edited it a bit:

```python
until: output.stdout.find("BABABA") == false
```

The issue is that the [`find()`](https://docs.python.org/3/library/stdtypes.html#str.find) method returns integer (position of the found substring). When Python compares integers with boolean values, it converts `True` to `1` and `False` to `0`. So the comparison will return `True` only when the substring position is `0` (the substring is at the beginning). Even if searching at the beginning was the goal, it's weird to compare the position with `false`.

The code that searches for substring at any position in stdout:

```python
until: output.stdout.find("BABABA") != -1
```

The documentation for the [`find()`](https://docs.python.org/3/library/stdtypes.html#str.find) method says that it should be used only if we need to know the position. To check if the substring is present in the string, the `in` operator should be used instead. So final version of this line:

```python
until: '"BABABA" in output.stdout'
```

### Roles

The given example was broken in multiple places. Fixed.

Also improved it a bit as an extra task: added template, separated into two separate roles.
