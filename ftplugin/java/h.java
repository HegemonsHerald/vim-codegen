
ArrayList<Integer> name = ;

Int name = ;

ArrayList<ArrayList<Integer>> name = ;

ArrayList<ArrayList<,Integer,Integer> name = ;


So there's a problem:

What if I want to enter stacked type parameter lists?

	> al
	> al,	=> al< al<...>,
	> i,	=> al< al<i,...>,
	> i	=> al< al<i,i>,...
	> i,	=> al< al<i,i>,i,...
	> d	=> al< al<i,i>,i,d >

How do we specify multiple levels of this shite?


Three cases:

	just comma
	just <
	both

	<<
	<,
	,,
	<
	,

use SplitStr with Regex: [<,]\{1,2}$
that matches < and , at the end of the line and maximally matches 2 of them.
you technically should also check, that there isn't something like ,, or << being played here, but frankly...

you could also just have each of the patterns and OR them:

	[^<,]\zs[<,]
	<,$


THIS LAST BIT IS THE SOLUTION!!!
