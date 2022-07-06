package javatest;

import java.lang.Math;
// import java.util.Collection;
// import java.util.Vector;
import java.util.*;

// import Constant;
public class Test {
    // public static final int UNEXPORED = 0;
    // public static final int AVAILABLE = 1;
    // public static final int OCCUPIED = 2;
    // public static int MapSize = 6;
    public static Point pt;
    public static Car mycar;
    public static Environment myenv;
    public static Point[][] mymap = new Point[Constant.MapSize][Constant.MapSize];

    public static void detect() {
        Constant.dectection_cnt++;
        if (mycar.Angle == 0) {
            int x = mycar.Position.x + 1;
            int y = mycar.Position.y;
            while (x < Constant.MapSize) {
                mymap[x][y].state = myenv.getstate(x, y);
                if (mymap[x][y].state == Constant.OCCUPIED) {
                    break;
                }
                x++;
            }
        } else if (mycar.Angle == 90) {
            int x = mycar.Position.x;
            int y = mycar.Position.y + 1;
            while (y < Constant.MapSize) {
                mymap[x][y].state = myenv.getstate(x, y);
                if (mymap[x][y].state == Constant.OCCUPIED) {
                    break;
                }
                y++;
            }
        } else if (mycar.Angle == 180) {
            int x = mycar.Position.x - 1;
            int y = mycar.Position.y;
            while (x >= 0) {
                mymap[x][y].state = myenv.getstate(x, y);
                if (mymap[x][y].state == Constant.OCCUPIED) {
                    break;
                }
                x--;
            }
        } else if (mycar.Angle == 270) {
            int x = mycar.Position.x;
            int y = mycar.Position.y - 1;
            while (y >= 0) {
                mymap[x][y].state = myenv.getstate(x, y);
                if (mymap[x][y].state == Constant.OCCUPIED) {
                    break;
                }
                y--;
            }
        }
    }

    public static void printstate(Point[][] map) {
        System.out.println("state map after " + Constant.dectection_cnt + " detections");
        for (int i = 0; i < Constant.MapSize; i++) {
            for (int j = 0; j < Constant.MapSize; j++) {
                System.out.print(map[i][j].state + " ");
            }
            System.out.println();
        }

    }

    public static Vector getneibghbor(Point p) {
        Vector neighbor = new Vector<Point>();
        if (p.x > 0) {
            neighbor.add(mymap[p.x - 1][p.y]);
        }
        if (p.x < Constant.MapSize - 1) {
            neighbor.add(mymap[p.x + 1][p.y]);
        }
        if (p.y > 0) {
            neighbor.add(mymap[p.x][p.y - 1]);
        }
        if (p.y < Constant.MapSize - 1) {
            neighbor.add(mymap[p.x][p.y + 1]);
        }
        return neighbor;
    }

    public static boolean isborder(Point p) {
        if (mymap[p.x][p.y].state != Constant.AVAILABLE) {
            return false;
        } else {
            Vector neighbor = getneibghbor(p);
            for (int i = 0; i < neighbor.size(); i++) {
                if (mymap[((Point) neighbor.get(i)).x][((Point) neighbor.get(i)).y].state == Constant.UNEXPORED) {
                    return true;
                }
            }
        }
        return false;
    }

    public static Vector getborder() {
        Vector border = new Vector<Point>();
        for (int i = 0; i < Constant.MapSize; i++) {
            for (int j = 0; j < Constant.MapSize; j++) {
                if (isborder(mymap[i][j])) {
                    border.add(mymap[i][j]);
                }
            }
        }
        return border;
    }

    public static void gotoneighbor(Point p) {
        if (mycar.Position.x == p.x && mycar.Position.y == p.y) {
            return;
        }
        if (p.state != Constant.AVAILABLE) {
            return;
        }
        if (p.x == mycar.Position.x) {
            if (p.y > mycar.Position.y) {
                // mycar.turnreset();
                // mycar.turnleft();
                mycar.turnto(90);
                mycar.move(1);
            } else {
                // mycar.turnreset();
                // mycar.turnright();
                mycar.turnto(270);
                mycar.move(1);
            }
        } else if (p.y == mycar.Position.y) {
            if (p.x > mycar.Position.x) {
                // mycar.turnreset();
                mycar.turnto(0);
                mycar.move(1);
            } else {
                // mycar.turnreset();
                // mycar.turnright();
                // mycar.turnright();
                mycar.turnto(180);
                mycar.move(1);
            }
        }
    }

    public static Vector findpath(Point Start, Point end) {
        if (end.state != Constant.AVAILABLE || (Start.x == end.x && Start.y == end.y)) {
            return null;
        }
        Vector path = new Vector<Point>();
        Vector queue = new Vector<Point>();
        queue.add(Start);
        boolean[][] visited = new boolean[Constant.MapSize][Constant.MapSize];
        Point[][] pathfrom = new Point[Constant.MapSize][Constant.MapSize];
        for (int i = 0; i < Constant.MapSize; i++) {
            for (int j = 0; j < Constant.MapSize; j++) {
                pathfrom[i][j] = new Point(-1, -1);
            }
        }
        visited[Start.x][Start.y] = true;
        while (!queue.isEmpty()) {
            Point point = (Point) queue.remove(0);
            Vector neighbor = getneibghbor(point);
            for (int i = 0; i < neighbor.size(); i++) {
                Point p = (Point) neighbor.get(i);
                if (p.state == Constant.AVAILABLE && !visited[p.x][p.y]) {
                    visited[p.x][p.y] = true;
                    pathfrom[p.x][p.y] = point;
                    queue.add(p);
                    if (p.x == end.x && p.y == end.y) {
                        path.add(p);
                        Point tem = pathfrom[p.x][p.y];
                        while (tem.x != Start.x || tem.y != Start.y) {
                            path.add(tem);
                            tem = pathfrom[tem.x][tem.y];
                        }
                        // return path;
                    }
                }
            }
        }
        return path;
    }

    public static void GoTo(Point target) {
        System.out.println("go to " + target.x + " " + target.y + " ");
        Vector path = findpath(mycar.Position, target);
        if (path != null) {
            for (int i = path.size() - 1; i >= 0; i--) {
                gotoneighbor((Point) path.get(i));
            }
        } else {
            System.out.println("no path");
        }
    }

    public static boolean needdetect(int angle) {
        int dx = (int) (Math.cos(angle * Math.PI / 180));
        int dy = (int) (Math.sin(angle * Math.PI / 180));
        int X = mycar.Position.x;
        int Y = mycar.Position.y;
        while (X < Constant.MapSize && X >= 0 && Y < Constant.MapSize && Y >= 0) {
            if (mymap[X][Y].state == Constant.OCCUPIED) {
                break;
            }
            if (mymap[X][Y].state == Constant.UNEXPORED) {
                return true;

            }
            X = X + dx;
            Y = Y + dy;
        }
        return false;
    }

    public static void detectaround() {
        int tem = mycar.Angle;
        for (int idx = 0; idx < 4; idx++) {
            if (needdetect(tem + idx * 90) == true) {
                mycar.turnto(tem + idx * 90);
                detect();

                // System.out.println(tem + idx * 90);

            }
        }
        // detect();
        // mycar.turnleft();
        // detect();
        // mycar.turnleft();
        // detect();
        // mycar.turnleft();
        // detect();


    }

    public static boolean allexplored() {
        for (int i = 0; i < Constant.MapSize; i++) {
            for (int j = 0; j < Constant.MapSize; j++) {
                if (mymap[i][j].state == Constant.UNEXPORED) {
                    return false;
                }
            }
        }
        return true;
    }

    public static void main(String[] args) {
        mycar = new Car(new Point(0, 0), 0);
        mymap = new Point[Constant.MapSize][Constant.MapSize];
        myenv = new Environment(Constant.MapSize);
        for (int i = 0; i < Constant.MapSize; i++) {
            for (int j = 0; j < Constant.MapSize; j++) {
                mymap[i][j] = new Point(i, j, Constant.UNEXPORED);
            }
        }

        // public static Point myPoint;
        System.out.println("Hello World"); // 输出 Hello World
        // System.out.println(AVAILABLE);
        myenv.printmap();
        mymap[0][0].state = Constant.AVAILABLE;
        printstate(mymap);
        detect();
        printstate(mymap);
        mycar.turnleft();
        detect();
        printstate(mymap);
        Vector havevisited = new Vector<Point>();
        havevisited.add(mymap[0][0]);
        for (int i = 0; i < (Constant.MapSize * Constant.MapSize); i++) {
            Vector border = getborder();
            for (int j = 0; j < border.size(); j++) {
                Point p = (Point) border.get(j);
                if (!havevisited.contains(p)) {
                    GoTo(p);
                    havevisited.add(p);
                    detectaround();
                    printstate(mymap);
                }
            }
            if (allexplored()) {
                break;
            }
        }
    }
}
