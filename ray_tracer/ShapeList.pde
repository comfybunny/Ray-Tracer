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
  
  public IntersectionObject intersects(Ray ray){
    // first check to see if ray hits the box
    Shape theShape = null;
    if(boundingBox.intersects(ray).getTime() < 0){
      return new IntersectionObject(-1, null);
    }
    float minTime = MAX_FLOAT;
    IntersectionObject intersectionInfo = null;
    for(Shape a : shapes){
      IntersectionObject currIntersectionInfo = a.intersects(ray);
      if(currIntersectionInfo.getTime() >= 0 && currIntersectionInfo.getTime() < minTime){
        theShape = a;
        minTime = currIntersectionInfo.getTime();
        intersectionInfo = currIntersectionInfo;
      }
    }
    if(intersectionInfo != null){
      intersectionInfo.setShape(theShape);
      return intersectionInfo;
    }
    return new IntersectionObject(-1, null);
  }
    
  public PVector shapeNormal(Point hitPoint){
    return new PVector();
  }
  
}