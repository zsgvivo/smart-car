package javatest;
import java.lang.Math;

public class Car {
    public Point Position;
    public int Angle;
    Car(Point pt, int angle)
    {
        Position = pt;
        Angle = angle;
    }
    public void turnleft() {
        Angle = (Angle + 90) % 360;
    }
    public void turnright() {
        Angle = (Angle + 270) % 360;
    }
    public void turnreset(){
        if(Angle == 0){
            return;
        }
        else if(Angle == 90){
            turnright();
        }
        else if(Angle == 180){
            turnright();
            turnright();
        }
        else if(Angle == 270){
            turnleft();
        }
    }
    public void move(int dist){
        Position.x += (int)(dist * Math.cos(Angle * Math.PI / 180));
        Position.y += (int)(dist * Math.sin(Angle * Math.PI / 180));
        System.out.println("Current Position:" + '(' + Position.x + ',' + Position.y + ')');
    }
}
