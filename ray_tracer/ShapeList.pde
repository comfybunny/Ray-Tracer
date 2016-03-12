public class ShapeList extends Shape{
  
  public String debug(){
    return "I am a shape list";
  }
  
  public IntersectionObject intersects(Ray tempRay){
    return null;
  }
    
  public PVector shapeNormal(Point hitPoint){
    return new PVector();
  }
  
}