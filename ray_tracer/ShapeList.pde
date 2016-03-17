public class ShapeList extends Shape{
  
  private ArrayList<Shape> shapes;
  private Box boundingBox;
  
  public ShapeList(ArrayList<Shape> shapes, Box boundingBox){
    this.shapes = shapes;
    this.boundingBox = boundingBox;
  }
  
  public ShapeList(Shape shape){
    shapes = new ArrayList<Shape>();
    shapes.add(shape);
  }
  
  public String debug(){
    return "I am an out of shape list";
  }
  
  public IntersectionObject intersects(Ray ray){
    // first check to see if ray hits the box
    //println("INTERSECTION BOX : " + boundingBox);
    //println("THYME : " + boundingBox.intersects(ray).getTime());
    
    if(boundingBox.intersects(ray).getTime() < 0){
      return new IntersectionObject(-1, null);
    }
    
    //return boundingBox.intersects(ray);
    ///**
    Shape theShape = null;
    float minTime = MAX_FLOAT;
    IntersectionObject intersectionInfo = null;
    // println("BOUNDING BOX PASSED YEE : " + boundingBox);
    for(Shape a : shapes){
      //println("checking " + a);
      IntersectionObject currIntersectionInfo = a.intersects(ray);
      if(currIntersectionInfo.getTime() > 0 && currIntersectionInfo.getTime() < minTime){
        //println("CHECKING " + a);
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
    //**/
  }
    
  public PVector shapeNormal(Point hitPoint){
    return new PVector();
  }
  
  public Box getBox(){
    return boundingBox;
  }
  
  public ArrayList<Shape> getShapes(){
    return shapes;
  }
}