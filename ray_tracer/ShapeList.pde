public class ShapeList extends Shape{
  
  private ArrayList<Shape> shapes;
  private Box boundingBox;
  
  public ShapeList(ArrayList<Shape> shapes, Box boundingBox){
    this.shapes = shapes;
    this.boundingBox = boundingBox;
  }
  
  public String debug(){
    return "I am an out of shape list";
  }
  
  public IntersectionObject intersects(Ray tempRay){
    return null;
  }
    
  public PVector shapeNormal(Point hitPoint){
    return new PVector();
  }
  
}