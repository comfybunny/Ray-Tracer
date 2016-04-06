import java.util.Collections;

public class BVH extends Shape{
  
  private ArrayList<Shape> shapes = null;
  private Box box;
  private Shape leftChild = null;
  private Shape rightChild = null;
  
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
  
  /**
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
  **/
  public void balance(int axis){
    int size = shapes.size();
    
    if(shapes != null){
      ArrayList<Shape> leftArray = new ArrayList<Shape>();
      ArrayList<Shape> rightArray = new ArrayList<Shape>();
      
      float centroid_x = (box.xmin+box.xmax)/2.0;
      float centroid_y = (box.ymin+box.ymax)/2.0;
      float centroid_z = (box.zmin+box.zmax)/2.0;
      
      
      for(int i=0; i<size; i++){
        
        Shape curr = shapes.remove(0);
        Point centroid = curr.getCentroid();
        
        if(axis == 0){
          if(centroid.getX() < centroid_x){
            leftArray.add(curr);
          }
          else{
            rightArray.add(curr);
          }
        }
        else if(axis == 1){
          if(centroid.getY() < centroid_y){
            leftArray.add(curr);
          }
          else{
            rightArray.add(curr);
          }
        }
        else if(axis == 2){
          if(centroid.getZ() < centroid_z){
            leftArray.add(curr);
          }
          else{
            rightArray.add(curr);
          }
        }
        else{
          println("BAD AXIS");
        }
        
      }
      
      if(shapes.size() != 0){
        println("YOU DONE GOOFED");
      }
      
      int leftArraySize = leftArray.size();      
      if(leftArraySize > 0){
        if(leftArraySize > 1){
          leftChild = new BVH(leftArray, leftArray.get(0).minPoint(), leftArray.get(0).maxPoint());
          for(int q = 1; q < leftArraySize; q++){
            leftChild.includePoint(leftArray.get(q).minPoint(), leftArray.get(q).maxPoint());
          }
          leftChild.balance((axis+1)%3);
        }
        else{
          leftChild = leftArray.get(0);
        }
      }
      
      int rightArraySize = rightArray.size();
      if(rightArraySize > 0){
        if(rightArraySize > 1){
          rightChild = new BVH(rightArray, rightArray.get(0).minPoint(), rightArray.get(0).maxPoint());
          for(int q = 1; q < rightArraySize; q++){
            rightChild.includePoint(rightArray.get(q).minPoint(), rightArray.get(q).maxPoint());
          }
          rightChild.balance((axis+1)%3);
        }
        else{
          rightChild = rightArray.get(0);
        }
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
  
  public Shape getLeft(){
    return leftChild;
  }
  
  public Shape getRight(){
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