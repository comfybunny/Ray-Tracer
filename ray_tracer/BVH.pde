public class BVH extends Box{
  
  private ArrayList<Shape> shapes;
  
  private BVH leftChild = null;
  private BVH rightChild = null;
  
  public BVH(ArrayList<Shape> shapes, Point min, Point max){
    super(min, max);
    this.shapes = shapes;
  }
  
  public IntersectionObject intersects(Ray tempRay){
    IntersectionObject thisHit = super.intersects(tempRay);
    if(thisHit.getTime() > 0){
      if(leftChild == null && rightChild == null){
        Shape theShape = null;
        float minTime = MAX_FLOAT;
        IntersectionObject intersectionInfo = null;
        for(Shape a : shapes){
          IntersectionObject currIntersectionInfo = a.intersects(tempRay);
          if(currIntersectionInfo.getTime() > 0 && currIntersectionInfo.getTime() < minTime){
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
      
      if(leftChild != null && rightChild != null){
        IntersectionObject leftIntersection = leftChild.intersects(tempRay);
        IntersectionObject rightIntersection = rightChild.intersects(tempRay);
        if(leftIntersection.getTime() > 0 && leftIntersection.getTime() < rightIntersection.getTime()){
          return leftIntersection;
        }
        return rightIntersection;
      }
      else if(leftChild != null){
        return leftChild.intersects(tempRay);
      }
      return rightChild.intersects(tempRay);

    }
    else{
      return thisHit;
    }
  }
  
  public void balance(){
    if(shapes.size() > 2){
      float x_range = xmax - xmin;
      float y_range = ymax - ymin;
      float z_range = zmax - zmin;
      // we want to split on the max ranged-box
      
      ArrayList<Shape> left = new ArrayList<Shape>();
      ArrayList<Shape> right = new ArrayList<Shape>();
      BVH leftBVH = null;
      BVH rightBVH = null;
      int shapeSize = shapes.size();
      println("SHAPE SIZE: " + shapeSize);
      if(x_range == max(x_range, y_range, z_range)){
        float centroid = xmin + x_range/2.0;
        
        for(int i=0; i<shapeSize; i++){
          if(shapes.get(0).getCentroid().getX() < centroid){
            if(leftBVH == null){
              leftBVH = new BVH(left, shapes.get(0).minPoint(), shapes.get(0).maxPoint());
            }
            else{
              leftBVH.includePoint(shapes.get(0).minPoint(), shapes.get(0).maxPoint());
            }
            left.add(shapes.get(0));
            shapes.remove(0);
          }
          else{
            if(rightBVH == null){
              rightBVH = new BVH(right, shapes.get(0).minPoint(), shapes.get(0).maxPoint());
            }
            else{
              rightBVH.includePoint(shapes.get(0).minPoint(), shapes.get(0).maxPoint());
            }
            right.add(shapes.get(0));
            shapes.remove(0);
          }
        }
        
      }
      else if(y_range == max(x_range, y_range, z_range)){
        float centroid = ymin + y_range/2.0;
        
        for(int i=0; i<shapeSize; i++){
          if(shapes.get(0).getCentroid().getY() < centroid){
            if(leftBVH == null){
              leftBVH = new BVH(left, shapes.get(0).minPoint(), shapes.get(0).maxPoint());
            }
            else{
              leftBVH.includePoint(shapes.get(0).minPoint(), shapes.get(0).maxPoint());
            }
            left.add(shapes.get(0));
            shapes.remove(0);
          }
          else{
            if(rightBVH == null){
              rightBVH = new BVH(right, shapes.get(0).minPoint(), shapes.get(0).maxPoint());
            }
            else{
              rightBVH.includePoint(shapes.get(0).minPoint(), shapes.get(0).maxPoint());
            }
            right.add(shapes.get(0));
            shapes.remove(0);
          }
        }
      }
      else{
        float centroid = zmin + z_range/2.0;
        
        for(int i=0; i<shapeSize; i++){
          if(shapes.get(0).getCentroid().getZ() < centroid){
            if(leftBVH == null){
              leftBVH = new BVH(left, shapes.get(0).minPoint(), shapes.get(0).maxPoint());
            }
            else{
              leftBVH.includePoint(shapes.get(0).minPoint(), shapes.get(0).maxPoint());
            }
            left.add(shapes.get(0));
            shapes.remove(0);
          }
          else{
            if(rightBVH == null){
              rightBVH = new BVH(right, shapes.get(0).minPoint(), shapes.get(0).maxPoint());
            }
            else{
              rightBVH.includePoint(shapes.get(0).minPoint(), shapes.get(0).maxPoint());
            }
            right.add(shapes.get(0));
            shapes.remove(0);
          }
        }
      }

      leftChild = leftBVH;
      rightChild = rightBVH;
      
      if(leftChild != null){
        println("LEFT SIZE: " + leftChild.getShapes().size());
        leftChild.balance();
      }
      if(rightChild != null){
        println("RIGHT SIZE: " + rightChild.getShapes().size());
        rightChild.balance();
      }
    }
  }
  
  public ArrayList<Shape> getShapes(){
    return shapes;
  }
  
  public String debug(){
    return "I AM A BVH";
  }
  
  public void printer(){
    println(shapes.size());
    println(leftChild.getShapes().size());
    println(rightChild.getShapes().size());
  }
}