public class Triangle extends Shape {
  
  private Point P1;
  private Point P2;
  private Point P3;
  
  public Triangle(Point P1, Point P2, Point P3, Surface surface){
    this.P1 = P1;
    this.P2 = P2;
    this.P3 = P3;
    addSurface(surface);
  }
  
  public float intersects(Ray tempRay){
    return 0;
  }
  
  public PVector shapeNormal(Point hitPoint){
    return new PVector();
  }

}