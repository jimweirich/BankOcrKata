# Bank OCR Kata

This repo contains two Ruby solutions to the Bank OCR Kata defined at
(http://www.codingdojo.org/cgi-bin/wiki.pl?KataBankOCR)

The first solution is on the master branch. The master branch as the
following tags:

* start-here -- User story specs, but no code.
* master-story1 -- The solution for user case 1
* master-story2 -- The solution for user case 2
* master-story3 -- The solution for user case 3
* master-story4 -- The solution for user case 4

The second implementation is on a branch named 'minimal'. It relies
only on the story specs and is a single file with hardly any domain
abstractions at all.

## User Story Specs

Each user story (defined below) has an input file and an answers file.
The command

<pre>
    rake stories
</pre>

will run all the stories that are at or below the compliance level
set in 'stories/story_spec.rb'. If you are working on story 1, then
set the compliance level to 1 so only that story will be tested
(stories above the compliance level are marked 'pending').

Note that the answers change for older stories as more requirements
are added. Therefore early stories have different answer files for
later compliance levels.

## Working the Kata Yourself

If you want to work this kata starting with this repo, then checkout
the tag 'start-here' in this repo. That will give you all the user
stories in a RSpec/Given format. Create a branch and work your own
solution.

Enjoy!

-- Jim Weirich (jimweirich on GitHub)

# Original Description (from the Coding Dojo wiki)

(see http://www.codingdojo.org/cgi-bin/wiki.pl?KataBankOCR)

This Kata was presented at XP2006 by EmmanuelGaillot and ChristopheThibaut.

## Problem Description

### User Story 1

You work for a bank, which has recently purchased an ingenious machine to assist in reading letters and faxes sent in by branch offices. The machine scans the paper documents, and produces a file with a number of entries which each look like this:

<pre>
    _  _     _  _  _  _  _
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|
</pre>

Each entry is 4 lines long, and each line has 27 characters. The first 3 lines of each entry contain an account number written using pipes and underscores, and the fourth line is blank. Each account number should have 9 digits, all of which should be in the range 0-9. A normal file contains around 500 entries.

Your first task is to write a program that can take this file and parse it into actual account numbers.

### User Story 2

Having done that, you quickly realize that the ingenious machine is not in fact infallible. Sometimes it goes wrong in its scanning. The next step therefore is to validate that the numbers you read are in fact valid account numbers. A valid account number has a valid checksum. This can be calculated as follows:

<pre>
account number:  3  4  5  8  8  2  8  6  5
position names:  d9 d8 d7 d6 d5 d4 d3 d2 d1
</pre>

checksum calculation:

(d1 + 2\*d2 + 3\*d3 +..+ 9\*d9) mod 11 = 0

So now you should also write some code that calculates the checksum
for a given number, and identifies if it is a valid account number.

### User Story 3

Your boss is keen to see your results. He asks you to write out a file
of your findings, one for each input file, in this format:

<pre>
457508000
664371495 ERR
86110??36 ILL
</pre>

ie. the file has one account number per row. If some characters are
illegible, they are replaced by a ?. In the case of a wrong checksum,
or illegible number, this is noted in a second column indicating
status.

### User Story 4

It turns out that often when a number comes back as ERR or ILL it is
because the scanner has failed to pick up on one pipe or underscore
for one of the figures. For example

<pre>
    _  _  _  _  _  _     _
|_||_|| || ||_   |  |  ||_
  | _||_||_||_|  |  |  | _|
</pre>

The 9 could be an 8 if the scanner had missed one |. Or the 0 could be
an 8. Or the 1 could be a 7. The 5 could be a 9 or 6. So your next
task is to look at numbers that have come back as ERR or ILL, and try
to guess what they should be, by adding or removing just one pipe or
underscore. If there is only one possible number with a valid
checksum, then use that. If there are several options, the status
should be AMB. If you still can't work out what it should be, the
status should be reported ILL.

## Clues

I recommend finding a way to write out 3x3 cells on 3 lines in your
code, so they form an identifiable digits. Even if your code actually
doesn't represent them like that internally. I'd much rather read

<pre>
"   " +
"|_|" +
"  |"
</pre>

than

<pre>
"   |_|  |"
</pre>

anyday.

When Christophe and Emmanuel presented this Kata at XP2005 they worked
on a solution that made extensive use of recursion rather than
iteration. Many people are more comfortable with iteration than
recursion. Try this kata both ways.

### Some gotchas to avoid:

- be very careful to read the definition of checksum correctly. It is
  not a simple dot product, the digits are reversed from what you
  expect.

- The spec does not list all the possible alternatives for valid
  digits when one pipe or underscore has been removed or added

- don't forget to try to work out what a ? should have been by adding
  or removing one pipe or underscore.

## Suggested Test Cases

If you want to just copy and paste these test cases into your editor,
I suggest first clicking "edit this page" so you can see the source.
Then you can be sure to copy across all the whitespace necessary. Just
don't save any changes by mistake.

### use case 1

<pre>
 _  _  _  _  _  _  _  _  _
| || || || || || || || || |
|_||_||_||_||_||_||_||_||_|

=> 000000000

  |  |  |  |  |  |  |  |  |
  |  |  |  |  |  |  |  |  |

=> 111111111
 _  _  _  _  _  _  _  _  _
 _| _| _| _| _| _| _| _| _|
|_ |_ |_ |_ |_ |_ |_ |_ |_

=> 222222222
 _  _  _  _  _  _  _  _  _
 _| _| _| _| _| _| _| _| _|
 _| _| _| _| _| _| _| _| _|

=> 333333333

|_||_||_||_||_||_||_||_||_|
  |  |  |  |  |  |  |  |  |

=> 444444444
 _  _  _  _  _  _  _  _  _
|_ |_ |_ |_ |_ |_ |_ |_ |_
 _| _| _| _| _| _| _| _| _|

=> 555555555
 _  _  _  _  _  _  _  _  _
|_ |_ |_ |_ |_ |_ |_ |_ |_
|_||_||_||_||_||_||_||_||_|

=> 666666666
 _  _  _  _  _  _  _  _  _
  |  |  |  |  |  |  |  |  |
  |  |  |  |  |  |  |  |  |

=> 777777777
 _  _  _  _  _  _  _  _  _
|_||_||_||_||_||_||_||_||_|
|_||_||_||_||_||_||_||_||_|

=> 888888888
 _  _  _  _  _  _  _  _  _
|_||_||_||_||_||_||_||_||_|
 _| _| _| _| _| _| _| _| _|

=> 999999999
    _  _     _  _  _  _  _
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

=> 123456789
</pre>

### use case 3
<pre>
 _  _  _  _  _  _  _  _
| || || || || || || ||_   |
|_||_||_||_||_||_||_| _|  |

=> 000000051
    _  _  _  _  _  _     _
|_||_|| || ||_   |  |  | _
  | _||_||_||_|  |  |  | _|

=> 49006771? ILL
    _  _     _  _  _  _  _
  | _| _||_| _ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _

=> 1234?678? ILL
</pre>

### use case 4
<pre>

  |  |  |  |  |  |  |  |  |
  |  |  |  |  |  |  |  |  |

=> 711111111
 _  _  _  _  _  _  _  _  _
  |  |  |  |  |  |  |  |  |
  |  |  |  |  |  |  |  |  |

=> 777777177
 _  _  _  _  _  _  _  _  _
 _|| || || || || || || || |
|_ |_||_||_||_||_||_||_||_|

=> 200800000
 _  _  _  _  _  _  _  _  _
 _| _| _| _| _| _| _| _| _|
 _| _| _| _| _| _| _| _| _|

=> 333393333
 _  _  _  _  _  _  _  _  _
|_||_||_||_||_||_||_||_||_|
|_||_||_||_||_||_||_||_||_|

=> 888888888 AMB ['888886888', '888888880', '888888988']
 _  _  _  _  _  _  _  _  _
|_ |_ |_ |_ |_ |_ |_ |_ |_
 _| _| _| _| _| _| _| _| _|

=> 555555555 AMB ['555655555', '559555555']
 _  _  _  _  _  _  _  _  _
|_ |_ |_ |_ |_ |_ |_ |_ |_
|_||_||_||_||_||_||_||_||_|

=> 666666666 AMB ['666566666', '686666666']
 _  _  _  _  _  _  _  _  _
|_||_||_||_||_||_||_||_||_|
 _| _| _| _| _| _| _| _| _|

=> 999999999 AMB ['899999999', '993999999', '999959999']
    _  _  _  _  _  _     _
|_||_|| || ||_   |  |  ||_
  | _||_||_||_|  |  |  | _|

=> 490067715 AMB ['490067115', '490067719', '490867715']
    _  _     _  _  _  _  _
 _| _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

=> 123456789
 _     _  _  _  _  _  _
| || || || || || || ||_   |
|_||_||_||_||_||_||_| _|  |

=> 000000051
    _  _  _  _  _  _     _
|_||_|| ||_||_   |  |  | _
  | _||_||_||_|  |  |  | _|

=> 490867715
</pre>