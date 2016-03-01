-- DSE 201 Databases 
-- HW #2, Cats Queries
--Student- Ryan Riopelle

--500 users total
--24060 friends total

--1)  Option “Overall Likes”: The Top-10 cat videos are the 
--ones that have collected the highest numbers of likes, overall.

SELECT 
  likes.video_id, count(likes.like_id) as countsum
FROM 
  cats.likes
Group By
  likes.video_id
Order By
  countsum  DESC
;



--2)  The Top-10 cat videos are the ones that have collected 
--the highest numbers of likes from the friends of X

--
SELECT 
  v.video_name
FROM 
  cats.likes l, 
  cats.video v
WHERE 
  l.video_id = v.video_id
  and l.user_id='2859'
  ;

--Needs nested query with friend chosen 
(SELECT 
  f.friend_id
FROM 
  cats.friend f, 
  cats."user" u
WHERE 
  u.user_id = f.user_id
  and u.user_name='Ian')

--answer

SELECT 
  v.video_name
FROM 
  cats.likes l, 
  cats.video v
WHERE 
  l.video_id = v.video_id
  and l.user_id IN (SELECT f.friend_id
		FROM cats.friend f, cats."user" u
		WHERE u.user_id = f.user_id
		and u.user_name='Ian'
  )
  ;
--If you want to show the friends which videos are associated with which friends

SELECT 
  v.video_name, u.user_name
FROM 
  cats.likes l, 
  cats.video v,
  cats."user" u
WHERE 
  l.video_id = v.video_id
  and l.user_id IN (SELECT f.friend_id
		FROM cats.friend f, cats."user" u
		WHERE u.user_id = f.user_id
		and u.user_name='Ian'
  )
  and u.user_id=l.user_id
  ;

  -- FINAL ANSWER, Show top videos that were liked by friends of 
  --user x= which here is shown as 'Ian'
SELECT 
  l.video_id, count(l.like_id) as countsum
FROM 
  cats.likes l, 
  cats.video v,
  cats."user" u
WHERE 
  l.video_id = v.video_id
  and l.user_id IN (SELECT f.friend_id
		FROM cats.friend f, cats."user" u
		WHERE u.user_id = f.user_id
		and u.user_name='Ian'
  )
  and u.user_id=l.user_id
Group By
  l.video_id
Order By
  countsum  DESC
  ;

--3)  Option “Friends-of-Friends Likes”: The Top-10 cat videos 
--are the ones that have collected the highest numbers of likes from friends and friends-of-friends.

--Friends of friends for all friends
SELECT 
 f.friend_id
FROM 
  cats.friend f
where
  f.user_id in (SELECT 
		f.friend_id
		FROM 
		cats.friend f,
		cats.user u
		where f.user_id=u.user_id
		)
 ;

 --Friends of friends for a specific user ID
 
 SELECT 
 f.friend_id
FROM 
  cats.friend f
where
  f.user_id in (SELECT 
		f.friend_id
		FROM 
		cats.friend f
		where f.user_id=1
		)
 ;


--4)  Option “My kind of cats”: The Top-10 cat videos are the ones that have 
--collected the most likes from users who have liked at least one cat video that was liked by X.


--5)  Option “My kind of cats – with preference (to cat aficionados that have the same tastes)”: 
--The Top-10 cat videos are the ones that have collected the highest sum of weighted likes from every 
--other user Y (i.e., given a cat video, each like on it, is multiplied according to a weight).
--The weight is the log cosine lc(X,Y) defined as follows: Conceptually, there is a vector vx for each user Y, including the logged-in user
--X. The vector has as many elements as the number of cat videos. Element i is 1 if Y liked the ith cat video; 
--it is 0 otherwise. For example, if 201Cats has five cat videos and user 21 liked only the 1st and the 4th, 
--the v21=<1,0,0,1,0>, i.e., v21[1]=v21[4]=1 and v21[2]= v21[3]=v21[5]=0. Assuming there are N cat videos, the log cosine lc(X, Y) is
