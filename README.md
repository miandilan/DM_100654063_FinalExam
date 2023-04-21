# DM_100654063_FinalExam
 
Task 1:
![image](https://user-images.githubusercontent.com/58942233/233693224-4fbd93fa-f0db-450b-8fc7-69f7d8e5cc62.png)

For this what I added was a generic plane for the backwall and floor with orange and tourquoise materials for each respectively. I did this since it was the easiest I could do. Then I added a script to the point lights in the scene to have them rotate around a center point light. The script is very simple here with just the rotate around method of transform being used. I did this since it was the simplest one I had and it has worked before. 
![image](https://user-images.githubusercontent.com/58942233/233694551-b25320b3-706a-41c0-aad3-a4f369d23df9.png)

Then I added a grey material for the player which is repesented by a capsule. I thought this would be an easy way to get the viewer to understand what was going on. 

Then I added a player movement script which is adapted from my previously used shark movement script. 
![image](https://user-images.githubusercontent.com/58942233/233694474-842c84d3-08e3-416e-b2e9-adcc8449b21a.png)

This clamps the player to the plane they are on and gives them basic movement on the plane. I did this since I thought it would be the easiest for this task and the script has worked with me before. The script gets the plane normals and uses an if statement for when the wasd buttons are pressed to move the player across the plane.


Task 2:

![image](https://user-images.githubusercontent.com/58942233/233696945-751133c0-fcba-43f6-a4a9-93c2be2426b5.png)

For this I was even numbered so I used a gravel texture image that I have used previously in the midterm in order to match the wallpaper look of the backwall. I added it as a normal map (in its own settings) to the normal map section of the generic material attached to the backwall. This was the best option for me since it required little work to edit the texture itself aside from having a new color (orange). 
