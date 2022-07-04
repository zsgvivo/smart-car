package javatest;

public class Point
{
    public int x;
    public int y;
    public int state;
    public Point(int a, int b, int c)
    {
        x = a;
        y = b;
        state = c;
    }   
    public Point(int a, int b)
    {
        x = a;
        y = b;
        state = Constant.UNEXPORED;
    }
}