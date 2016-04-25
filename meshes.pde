// Sample code for starting the meshes project

import processing.opengl.*;
import java.util.Random;

float time = 0;  // keep track of passing of time (for automatic rotation)
boolean rotate_flag = true;       // automatic rotation of model?

boolean perFaceNormal = true;    //otherwise, per-vertex normal

Polyhedron poly;
Random random;

// initialize stuff
void setup() {
  poly = new Polyhedron();
  random = new Random();
  size(400, 400, OPENGL);  // must use OPENGL here !!!
  noStroke();     // do not draw the edges of polygons
}

// Draw the scene
void draw()
{
  resetMatrix();  // set the transformation matrix to the identity (important!)

  background(0);  // clear the screen to black
  
  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);
  
  // place the camera in the scene (just like gluLookAt())
  camera (0.0, 0.0, 5.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);

  scale (1.0, -1.0, 1.0);  // change to right-handed coordinate system
  
  // create an ambient light source
  ambientLight(102, 102, 102);
  
  // create two directional light sources
  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, -0.7, -0.7, -1);
  directionalLight(152, 152, 152, 0, 0, -1);
  
  pushMatrix();

  fill(50, 50, 200);            // set polygon color to blue
  ambient (200, 200, 200);
  specular(0, 0, 0);
  shininess(1.0);
  
  rotate (time, 1.0, 0.0, 0.0);
  
  // THIS IS WHERE YOU SHOULD DRAW THE MESH
  for(int i = 0; i < poly.numFaces(); i++)
  {
    Face face = poly.getFace(i);
    PVector v1 = poly.getVertex(face.v1);
    PVector v2 = poly.getVertex(face.v2);
    PVector v3 = poly.getVertex(face.v3);
    
    fill(face.r, face.g, face.b);
    
    if(perFaceNormal)
    {
      PVector normal = poly.normalAtFace(face);
      
      beginShape();
      
      normal(normal.x, normal.y, normal.z);
      vertex(v1.x, v1.y, v1.z);
      vertex(v2.x, v2.y, v2.z);
      vertex(v3.x, v3.y, v3.z);
      
      endShape(CLOSE);
    }
    else
    {
      /***** CALCULATE V1 NORMAL *****/
      Face[] v1Faces = poly.getFacesAtVertex(v1);
      PVector v1Normal = new PVector(0, 0, 0);
      
      for(Face v1Face: v1Faces)
      {
        v1Normal = PVector.add(v1Normal, poly.normalAtFace(v1Face));
      }
      
      v1Normal.normalize();
      
      /***** CALCULATE V2 NORMAL *****/
      Face[] v2Faces = poly.getFacesAtVertex(v2);
      PVector v2Normal = new PVector(0, 0, 0);
      
      for(Face v2Face: v2Faces)
      {
        v2Normal = PVector.add(v2Normal, poly.normalAtFace(v2Face));
      }
      
      v2Normal.normalize();
      
      /***** CALCULATE V3 NORMAL *****/
      Face[] v3Faces = poly.getFacesAtVertex(v3);
      PVector v3Normal = new PVector(0, 0, 0);
      
      for(Face v3Face: v3Faces)
      {
        v3Normal = PVector.add(v3Normal, poly.normalAtFace(v3Face));
      }
      
      v3Normal.normalize();
      
      beginShape();
      
      normal(v1Normal.x, v1Normal.y, v1Normal.z);
      vertex(v1.x, v1.y, v1.z);
      
      normal(v2Normal.x, v2Normal.y, v2Normal.z);
      vertex(v2.x, v2.y, v2.z);
      
      normal(v2Normal.x, v2Normal.y, v2Normal.z);
      vertex(v3.x, v3.y, v3.z);
      
      endShape(CLOSE);
    }
  }

  popMatrix();
 
  // maybe step forward in time (for object rotation)
  if (rotate_flag )
    time += 0.02;
}

// handle keyboard input
void keyPressed() {
  if (key == '1') {
    read_mesh ("tetra.ply");
  }
  else if (key == '2') {
    read_mesh ("octa.ply");
  }
  else if (key == '3') {
    read_mesh ("icos.ply");
  }
  else if (key == '4') {
    read_mesh ("star.ply");
  }
  else if (key == '5') {
    read_mesh ("torus.ply");
  }
  else if (key == ' ') {
    rotate_flag = !rotate_flag;          // rotate the model?
  }else if (key == 'n') {
    perFaceNormal = !perFaceNormal;
  }else if (key == 'r') {
    for(int i = 0; i < poly.numFaces(); i++)
    {
      poly.getFace(i).r = random.nextInt(256);
      poly.getFace(i).g = random.nextInt(256);
      poly.getFace(i).b = random.nextInt(256);
    }
  }else if (key == 'w') {
    for(int i = 0; i < poly.numFaces(); i++)
    {
      poly.getFace(i).r = 255;
      poly.getFace(i).g = 255;
      poly.getFace(i).b = 255;
    }
  }else if (key == 'd') {
    //calculate mesh dual
  }else if (key == 'q' || key == 'Q') {
    exit();                               // quit the program
  }
}

// Read polygon mesh from .ply file
//
// You should modify this routine to store all of the mesh data
// into a mesh data structure instead of printing it to the screen.
void read_mesh (String filename)
{
  int i;
  String[] words;
  
  String lines[] = loadStrings(filename);
  
  words = split (lines[0], " ");
  int num_vertices = int(words[1]);
  
  words = split (lines[1], " ");
  int num_faces = int(words[1]);

  PVector[] vertices = new PVector[num_vertices];
  Face[] faces = new Face[num_faces];
  
  // read in the vertices
  for (i = 0; i < num_vertices; i++) {
    words = split (lines[i+2], " ");
    float x = float(words[0]);
    float y = float(words[1]);
    float z = float(words[2]);
    vertices[i] = new PVector(x, y, z);
  }
  
  // read in the faces
  for (i = 0; i < num_faces; i++)
  {
    
    int j = i + num_vertices + 2;
    words = split (lines[j], " ");
    
    int nverts = int(words[0]);
    if (nverts != 3)
    {
      println ("error: this face is not a triangle.");
      exit();
    }
    
    int index1 = int(words[1]);
    int index2 = int(words[2]);
    int index3 = int(words[3]);

    faces[i] = new Face(index1, index2, index3);
  }

   poly = new Polyhedron(vertices, faces);
}