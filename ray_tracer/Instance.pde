public class Instance extends Shape{
  
  Shape shape;
  XMatrix3D transformation_matrix_inverse;
  
  public Instance(Shape shape, XMatrix3D ctm){
    this.shape = shape;
    this.transformation_matrix_inverse = ctm.getInverse();
    //transformation_matrix_inverse.printDebug();
  }
  
  public String debug(){
    return "I am an instance";
  }
  
  public PVector shapeNormal(Point hitPoint){
    return shape.shapeNormal(hitPoint);
  }
  
  public IntersectionObject intersects(Ray tempRay){
    Point old_origin = tempRay.getOrigin();
    PVector old_direction = tempRay.getDirection();
    //first transform the ray by this stored matrix
    float[] transformed_origin = transformation_matrix_inverse.vectorMultiply(new float[]{old_origin.getX(), old_origin.getY(), old_origin.getZ(), 1});
    //float[] direction = transformation_matrix_inverse.vectorMultiply(new float[]{old_direction.x, old_direction.y, old_direction.z, 1});
    PVector new_direction = transformation_matrix_inverse.PVectorMultiply(old_direction);
    Ray transformed_ray = new Ray(new Point(transformed_origin[0], transformed_origin[1], transformed_origin[2]), new_direction);
    
    /**
    transformation_matrix_inverse.printDebug();
    println();
    println(tempRay.debug());
    println(transformed_ray.debug());
    println();
    **/
    
    IntersectionObject intersection =  shape.intersects(transformed_ray);
    //println(intersection.getTime());
    if(intersection.getTime() > 0){
      intersection.setSurfaceNormal(transformation_matrix_inverse.multiplyAdjoint(intersection.getSurfaceNormal()));
      // println(transformed_ray.hitPoint(intersection.getTime()).toString());
      intersection.setIntersectionPoint(transformed_ray.hitPoint(intersection.getTime()));
      //println(intersection.getIntersectionPoint().toString());
    }
    
    
    return intersection;
  }
  
  public Surface getSurface(){
    return shape.getSurface();
  }
  
}