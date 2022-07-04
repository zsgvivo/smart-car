package javatest;

public class Environment {
    int[][] map;
    Environment(int size) {//生成随机地图
        map = new int[size][size];
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                map[i][j] = (int)(Math.random()*100) % 2;
            }
        }
        map[0][0] = 0;
    }
    Environment(int[][] m) {//生成指定地图
        map = m;
    }
    public void printmap(){
        for (int i = 0; i < map.length; i++) {
            for (int j = 0; j < map.length; j++) {
                System.out.print(map[i][j] + " ");
            }
            System.out.println();
        }
    }
    public int getstate(int x, int y) {
        if(map[x][y] == 0){
            return Constant.AVAILABLE;
        }
        else{
            return Constant.OCCUPIED;
        }
    }
}
