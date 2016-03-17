import java.lang.Math.*;

public class Grids extends Shape{
  
  ShapeList[][][] grid;
  Box box;
  
  public Grids(ArrayList<Shape> shapes, Box box){
    this.box = box;
    int sideLength = (int)Math.cbrt(shapes.size()/2);
    grid = new ShapeList[sideLength][sideLength][sideLength];
    for(int i=0; i<shapes.size(); i++){
      Point minPoint = shapes.get(i).minPoint();
      Point maxPoint = shapes.get(i).maxPoint();
    }
  }
  public String debug(){
    return "GRID";
  }
  
  public IntersectionObject intersects(Ray tempRay){
    return null;
  }
    
  public PVector shapeNormal(Point hitPoint){
    return new PVector();
  }
  
}