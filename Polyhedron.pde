import java.util.ArrayList;
import java.util.List;

public class Polyhedron
{
    private PVector[] vertices;
    private Face[] faces;

    public Polyhedron()
    {
        vertices = new PVector[0];
        faces = new Face[0];
    }

    public Polyhedron(PVector[] vertices, Face[] faces)
    {
        this.vertices = vertices;
        this.faces = faces;
    }

    public int numVertices()
    {
        return vertices.length;
    }

    public int numFaces()
    {
        return faces.length;
    }

    public PVector getVertex(int n)
    {
        return vertices[n];
    }

    public Face getFace(int n)
    {
        return faces[n];
    }
    
    public Face[] getFacesAtVertex(PVector vertex)
    {
        List<Face> list = new ArrayList();
      
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
    
    // This method takes in a time variable as a bit of a hack...
    // If we know the amount that the scene is rotated, we can determine
    // whether a vector is facing toward or away from the camera. If the
    // normal is facing AWAY at the given point in time, just multiply
    // it by negative 1.
    public PVector normalAtFace(Face face, float time)
    {
        PVector v1 = vertices[face.v1];
        PVector v2 = vertices[face.v2];
        PVector v3 = vertices[face.v3];
      
        PVector v13 = PVector.sub(v3, v1);
        PVector v12 = PVector.sub(v2, v1);
      
        PVector normal = v13.cross(v12);
        normal.normalize();
      
        // rotate normal vector around X axis by the amount that we know the
        // main scene will be rotated at
        float normalZPostRotate = (float)(Math.sin(time) * normal.y + Math.cos(time) * normal.z);
        
        if(normalZPostRotate < 0)
        {
            normal.mult(-1);
        }
        
        return normal;
    }

    public Polyhedron dual()
    {
        List<PVector> newVertices = new ArrayList();
        List<Face> newFaces = new ArrayList();

        for(PVector vertex: vertices)
        {
            Face[] facesAtVertex = getFacesAtVertex(vertex);
            List<PVector> centroids = new ArrayList();

            // Find centroid of each face. Add it to list, which we
            // use to calculate centroid of centroids
            for(Face face: facesAtVertex)
            {
                PVector v1 = vertices[face.v1];
                PVector v2 = vertices[face.v2];
                PVector v3 = vertices[face.v3];

                //sum up vertices
                PVector centroid = PVector.add(PVector.add(v1, v2), v3);

                //divide by 3 (since 3 vertices) to get centroid
                centroid.div(3.0);

                centroids.add(centroid);
            }

            // Calculate centroid of centroids
            
            PVector centroidOfCentroids = new PVector(0, 0, 0);
            
            for(PVector centroid: centroids)
            {
                centroidOfCentroids.add(centroid);
            }

            centroidOfCentroids.div((float)centroids.size());

            // Check each face around vertex against each other to
            // detect opposites. When opposites found, use their
            // centroid along w/ the centroid of centroids to make a
            // new face

            for(int i = 0; i < facesAtVertex.length - 1; i++)
            {
                for(int j = i + 1; j < facesAtVertex.length; j++)
                {
                    if(facesAtVertex[i].isOpposite(facesAtVertex[j]))
                    {
                        int v1 = newVertices.indexOf(centroids.get(i));

                        // vertex isn't in list yet
                        if(v1 == -1)
                        {
                            v1 = newVertices.size();
                            newVertices.add(centroids.get(i));
                        }

                        int v2 = newVertices.indexOf(centroids.get(j));

                        // vertex isn't in list yet
                        if(v2 == -1)
                        {
                            v2 = newVertices.size();
                            newVertices.add(centroids.get(j));
                        }

                        int v3 = newVertices.size();
                        newVertices.add(centroidOfCentroids);
                        
                        newFaces.add(new Face(v1, v2, v3));
                    }
                }
            }
         }

        PVector[] v = newVertices.toArray(new PVector[0]);
        Face[] f = newFaces.toArray(new Face[0]);

        return new Polyhedron(v, f);
    }
}