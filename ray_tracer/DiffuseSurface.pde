public class DiffuseSurface{
  private Color diffuseCoefficient;
  private Color ambientCoefficient;
  
  public DiffuseSurface(Color diffuseCoefficient, Color ambientCoefficient){
    this.diffuseCoefficient = diffuseCoefficient;
    this.ambientCoefficient = ambientCoefficient;
  }
  
  public Color getDiffuseCoefficient(){
    return diffuseCoefficient;
  }
  
  public Color getAmbientCoefficient(){
    return ambientCoefficient;
  }
}