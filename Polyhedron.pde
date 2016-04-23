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
}