import java.util.Collections;

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
        if(leftIntersection.getTime() > 0 && (leftIntersection.getTime() < rightIntersection.getTime() || rightIntersection.getTime() < 0)){
          return leftChild.intersects(tempRay);
        }
        return rightChild.intersects(tempRay);
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
  
  public IntersectionObject intersectPrint(Ray tempRay){
    IntersectionObject thisHit = super.intersects(tempRay);
    println(thisHit.getTime());
    if(thisHit.getTime() > 0){
      if(leftChild == null && rightChild == null){
        println("LEFT CHILD RIGHT CHILD BOTH NULL");
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
           println("intersection forreal time  \t" + intersectionInfo.getTime());
          intersectionInfo.setShape(theShape);
          return intersectionInfo;
        }
        return new IntersectionObject(-1, null);
      }
      
      if(leftChild != null && rightChild != null){
        println("LEFT CHILD RIGHT CHILD BOTH NOT NULL");
        IntersectionObject leftIntersection = leftChild.intersects(tempRay);
        IntersectionObject rightIntersection = rightChild.intersects(tempRay);
        println("leftIntersection \t" + leftIntersection.getTime());
        println("rightIntersection \t" + rightIntersection.getTime());
        if(leftIntersection.getTime() > 0 && (leftIntersection.getTime() < rightIntersection.getTime() || rightIntersection.getTime() < 0)){
          println("GOING TO LEFT CHILD");
          return leftChild.intersectPrint(tempRay);
        }
        return rightChild.intersectPrint(tempRay);
      }
      else if(leftChild != null){
        println("LEFT CHILD NOT NULL");
        return leftChild.intersects(tempRay);
      }
      println("RIGHT CHILD NOT NULL");
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
      // println("SHAPE SIZE: " + shapeSize);
      ArrayList<Float> xs = new ArrayList<Float>();
      ArrayList<Float> ys = new ArrayList<Float>();
      ArrayList<Float> zs = new ArrayList<Float>();
      for(int q = 0; q < shapeSize; q++){
        Point curr = shapes.get(q).getCentroid();
        xs.add(curr.getX());
        ys.add(curr.getY());
        zs.add(curr.getZ());
      }
      Collections.sort(xs);
      Collections.sort(ys);
      Collections.sort(zs);
      if(x_range == max(x_range, y_range, z_range)){
        float centroid = xs.get(xs.size()/2);
        
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
        float centroid = ys.get(ys.size()/2);;
        
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
        float centroid = zs.get(zs.size()/2);
        
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
        // println("LEFT SIZE: " + leftChild.getShapes().size());
        leftChild.balance();
      }
      if(rightChild != null){
        // println("RIGHT SIZE: " + rightChild.getShapes().size());
        rightChild.balance();
      }
    }
  }
  
  public ArrayList<Shape> getShapes(){
    return shapes;
  }
  
  public int getSize(){
    return shapes.size();
  }
  
  public String debug(){
    return "I AM A BVH";
  }
  
  public BVH getLeft(){
    return leftChild;
  }
  
  public BVH getRight(){
    return rightChild;
  }
}