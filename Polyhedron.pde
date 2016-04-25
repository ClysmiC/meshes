import java.util.ArrayList;

public class Polyhedron {
    private PVector[] vertices;
    private Face[] faces;

    public Polyhedron() {
        vertices = new PVector[0];
        faces = new Face[0];
    }

    public Polyhedron(PVector[] vertices, Face[] faces) {
        this.vertices = vertices;
        this.faces = faces;
    }

    public int numVertices() {
        return vertices.length;
    }

    public int numFaces() {
        return faces.length;
    }

    public PVector getVertex(int n) {
        return vertices[n];
    }

    public Face getFace(int n) {
        return faces[n];
    }
    
    public Face[] getFacesAtVertex(PVector vertex) {
      ArrayList<Face> list = new ArrayList();
      
      for(Face face: faces)
      {
        PVector v1 = vertices[face.v1];
        PVector v2 = vertices[face.v2];
        PVector v3 = vertices[face.v3];
        
        if(vertex == v1 || vertex == v2 || vertex == v3)
        {
          list.add(face);
        }
      }
      
      return list.toArray(new Face[0]);
    }
    
    public PVector normalAtFace(Face face)
    {
      PVector v1 = vertices[face.v1];
      PVector v2 = vertices[face.v2];
      PVector v3 = vertices[face.v3];
      
      PVector v13 = PVector.sub(v3, v1);
      PVector v12 = PVector.sub(v2, v1);
      
      PVector normal = v13.cross(v12);
      normal.normalize();
      
      if(v2.mag() > PVector.add(v2, normal).mag())
      {
        normal.mult(-1);
      }
        
      return normal;
    }
}