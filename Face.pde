/**
 * A triangular face. Holds the index into the vertex list that
 * each point of the triangle is represented by.
 */
public class Face
{
    public int v1, v2, v3;
    public int r, g, b;

    public Face(int v1, int v2, int v3)
    {
      this.v1 = v1;
      this.v2 = v2;
      this.v3 = v3;
      
      r = g = b = 255;
    }

    public boolean isOpposite(Face other)
    {
        if (this == other)
            return false;

        int sharedVertices = 0;

        if (v1 == other.v1 || v1 == other.v2 || v1 == other.v3)
        {
            sharedVertices += 1;   
        }

        if (v2 == other.v1 || v2 == other.v2 || v2 == other.v3)
        {
            sharedVertices += 1;   
        }
        
        if (v3 == other.v1 || v3 == other.v2 || v3 == other.v3)
        {
            sharedVertices += 1;   
        }
        
        return sharedVertices == 2;
    }
}
