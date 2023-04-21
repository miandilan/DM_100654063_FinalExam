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

For this I was even numbered so I used a gravel texture image (from this website https://3dtextures.me/) that I have used previously in the midterm in order to match the wallpaper look of the backwall. I added it as a normal map (in its own settings) to the normal map section of the generic material attached to the backwall. This was the best option for me since it required little work to edit the texture itself aside from having a new color (orange). 


Task 3:

![image](https://user-images.githubusercontent.com/58942233/233708283-6a38dc5a-99df-4ef0-9bbd-71b28f1cdb34.png)

For this I added a the water displacement shader which I got from the slides. I used it since it was the easiest for me. The shader uses the vertex and fragement shader to manipulate the amplitude, frequency, and speed of the waves with sin functions. 
![image](https://user-images.githubusercontent.com/58942233/233708767-77d265fd-2df9-4aaa-8bba-2e85fc71a645.png)

I used a lava texture from https://3dtextures.me/ since I thought it would be the easiest and most aesthetically appealing option. I then decided to make a new c# script to make the float Speed value from the shader to be toggleable with the buttons 1 and 2. By pressing 1, the speed toggles to 50 and then to 10 if I press 2. I used an OnRender function to actually connect to the speed variable from the shader. I thought this was the most convenient way to change the value:

![image](https://user-images.githubusercontent.com/58942233/233709289-bd470bb8-b0f1-482c-86bb-d3826360dbfc.png)

Below is what this looks like in the inspector:

![image](https://user-images.githubusercontent.com/58942233/233709513-bc8f1a79-91dd-446b-aa10-ecb32a758b9c.png)

As a flowchart, it goes like this:

Vertex Function calculates wave amplitude, frequency, and speed with 2 sin functions -> C# has option to press 1 -> 1 is pressed -> speed changes to 50.
