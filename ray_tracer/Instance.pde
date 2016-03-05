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
    float[] transformed_origin = transformation_matrix_inverse.vectorMultiply(new float[]{old_origin.getX(), old_origin.getY(), old_origin.getZ()});
    PVector direction = transformation_matrix_inverse.PVectorMultiply(old_direction);
    Ray transformed_ray = new Ray(new Point(transformed_origin[0], transformed_origin[1], transformed_origin[2]), direction);
    IntersectionObject intersection =  shape.intersects(transformed_ray);
    if(intersection.getSurfaceNormal() != null){
      intersection.setSurfaceNormal(transformation_matrix_inverse.multiplyAdjoint(intersection.getSurfaceNormal()));
    }
    return intersection;
  }
  
  public Surface getSurface(){
    return shape.getSurface();
  }
  
}