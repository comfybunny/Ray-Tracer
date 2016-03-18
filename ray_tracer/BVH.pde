import java.util.Collections;

public class BVH extends Shape{
  
  private ArrayList<Shape> shapes;
  
  private Box box;
  private BVH leftChild = null;
  private BVH rightChild = null;
  
  public BVH(ArrayList<Shape> shapes, Point min, Point max){
    box = new Box(min, max);
    this.shapes = shapes;
  }
  
  public IntersectionObject intersects(Ray tempRay){
    IntersectionObject thisHit = box.intersects(tempRay);
    if(thisHit.getTime() > 0){
      if(leftChild == null && rightChild == null){
        float minTime = MAX_FLOAT;
        IntersectionObject intersectionInfo = null;
        // println(shapes.size());
        for(Shape a : shapes){
          IntersectionObject currIntersectionInfo = a.intersects(tempRay);
          if(currIntersectionInfo.getTime() > 0 && currIntersectionInfo.getTime() < minTime){
            minTime = currIntersectionInfo.getTime();
            intersectionInfo = currIntersectionInfo;
          }
        }
        if(intersectionInfo != null){
          return intersectionInfo;
        }
        return new IntersectionObject(-1, null);
      }
      
      if(leftChild != null && rightChild != null){
        IntersectionObject leftIntersection = leftChild.getBox().intersects(tempRay);
        IntersectionObject rightIntersection = rightChild.getBox().intersects(tempRay);
        if(leftIntersection.getTime() == rightIntersection.getTime()){
          IntersectionObject left = leftChild.intersects(tempRay);
          IntersectionObject right = rightChild.intersects(tempRay);
          if(left.getTime() > 0 && (left.getTime() < right.getTime() || right.getTime() < 0)){
            return left;
          }
          if(right.getTime() > 0){
            return right;
          }
          return new IntersectionObject(-1, null);
        }
        if(leftIntersection.getTime() > 0 && (leftIntersection.getTime() < rightIntersection.getTime() || rightIntersection.getTime() < 0)){
          return leftChild.intersects(tempRay);
        }
        if(rightIntersection.getTime() > 0){
          return rightChild.intersects(tempRay);
        }
        return new IntersectionObject(-1, null);
        
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
    println("THIS BOX: " + getBox().debug());
    IntersectionObject thisHit = getBox().intersects(tempRay);
    println(thisHit.getTime());
    if(thisHit.getTime() > 0){
      if(leftChild == null && rightChild == null){
        println("LEFT CHILD RIGHT CHILD BOTH NULL");
        Shape theShape = null;
        float minTime = MAX_FLOAT;
        IntersectionObject intersectionInfo = null;
        println("NUM SHAPES: " + shapes.size());
        for(Shape a : shapes){
          if(a.getClass().equals(Triangle.class)){
            println();
            println(tempRay.debug());
          }
          IntersectionObject currIntersectionInfo = ((Triangle)a).intersects(tempRay);
          println(currIntersectionInfo.getTime());
          println(a.debug());
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
        println("LEFT BOX: " + leftChild.getBox().debug());
        IntersectionObject leftIntersection = leftChild.getBox().intersects(tempRay);
        println("RIGHT BOX: " + rightChild.getBox().debug());
        IntersectionObject rightIntersection = rightChild.getBox().intersects(tempRay);
        println("leftIntersection \t" + leftIntersection.getTime());
        println("rightIntersection \t" + rightIntersection.getTime());
        if(leftIntersection.getTime() == rightIntersection.getTime()){
          println("EQUAL TIME CHECKING BOTH");
          println("EQUAL TIME CHECKING LEFT CHILD");
          IntersectionObject left = leftChild.intersectPrint(tempRay);
          println("EQUAL TIME CHECKING RIGHT CHILD");
          IntersectionObject right = rightChild.intersectPrint(tempRay);
          println("EQUAL TIME DONE CHECKING CHILDREN");
          
          println("left.getTime(): " + left.getTime() + "\tright.getTime(): " + right.getTime());
          if(left.getTime() > 0 && (left.getTime() < right.getTime() || right.getTime() < 0)){
            return left;
          }
          if(right.getTime() > 0){
            return right;
          }
          return new IntersectionObject(-1, null);
        }
        if(leftIntersection.getTime() > 0 && (leftIntersection.getTime() < rightIntersection.getTime() || rightIntersection.getTime() < 0)){
          println("GOING TO LEFT CHILD");
          return leftChild.intersectPrint(tempRay);
        }
        
        if(rightIntersection.getTime() > 0){
          println("GOING TO RIGHT CHILD");
          return rightChild.intersectPrint(tempRay);
        }
        return new IntersectionObject(-1, null);
        
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
    int shapeSize = shapes.size();
    if(shapeSize > 2){
      float x_range = box.xmax - box.xmin;
      float y_range = box.ymax - box.ymin;
      float z_range = box.zmax - box.zmin;
      // we want to split on the max ranged-box
      
      ArrayList<Shape> left = new ArrayList<Shape>();
      ArrayList<Shape> right = new ArrayList<Shape>();
      BVH leftBVH = null;
      BVH rightBVH = null;
      
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
        float centroid = xs.get(shapeSize/2);
        
        for(int i=0; i<shapeSize; i++){
          Triangle curr = (Triangle)shapes.remove(0);
          if(curr.getCentroid().getX() < centroid){
            if(leftBVH == null){
              leftBVH = new BVH(left, curr.minPoint(), curr.maxPoint());
            }
            else{
              leftBVH.includePoint(curr.minPoint(), curr.maxPoint());
            }
            left.add(curr);
          }
          else{
            if(rightBVH == null){
              rightBVH = new BVH(right, curr.minPoint(), curr.maxPoint());
            }
            else{
              rightBVH.includePoint(curr.minPoint(), curr.maxPoint());
            }
            right.add(curr);
          }
        }
      }
      else if(y_range == max(x_range, y_range, z_range)){
        float centroid = ys.get(shapeSize/2);;
        
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
        float centroid = zs.get(shapeSize/2);
        
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
  
  public Box getBox(){
    return box;
  }

  public void includePoint(Point minPoint, Point maxPoint){
    box.includePoint(minPoint, maxPoint);
  }
  
  public PVector shapeNormal(Point hitPoint){
    return box.shapeNormal(hitPoint);
  }
}