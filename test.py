import math
import random

UNEXPLORED = 0
AVAILABLE = 1
OCCUPIED = 2
MapSize = 6
detection_cnt = 0

class Point:
    def __init__(self, x, y, state=UNEXPLORED):
        self.x = x
        self.y = y
        self.state = state
    def __str__(self):
        return f"({self.x}, {self.y})"
class Car:
    def __init__(self, Position, Angle):
        self.Position = Position
        self.Angle = Angle
    def TurnLeft(self):
        self.Angle += 90
    def TurnRight(self):
        self.Angle -= 90
    def move(self, distance):
        self.Position.x += distance * math.cos(math.radians(self.Angle))
        self.Position.y += distance * math.sin(math.radians(self.Angle))
class Environment:#测试用
    def __init__(self, Map):# Map 是二维01数组,1表示该处有障碍
        self.Map = Map
    def GetState(self, Point):
        if self.Map[Point.x][Point.y] == 1:
            return OCCUPIED
        else:
            return AVAILABLE
def generate_random_map(mapsize):
    map = []
    for i in range(mapsize):
        map.append([])
        for j in range(mapsize):
            map[i].append(random.choices([0, 1], weights=[1, 0.5])[0])
    map[0][0] = 0
    print("generate random map:")
    # for i in range(mapsize):
    Print(map)
        # print("\n")
    return map
def Detect(MyCar, MyMap, environment):
    global detection_cnt
    detection_cnt += 1
    if MyCar.Angle == 0:
        x = MyCar.Position.x + 1
        y = MyCar.Position.y
        while x < MapSize:
            MyMap[x][y].state = environment.GetState(Point(x, y))
            if MyMap[x][y].state == OCCUPIED:
                break
            x += 1
    elif MyCar.Angle == 90:
        x = MyCar.Position.x
        y = MyCar.Position.y + 1
        while y < MapSize:
            MyMap[x][y].state = environment.GetState(Point(x, y))
            if MyMap[x][y].state == OCCUPIED:
                break
            y += 1
    elif MyCar.Angle == 180:
        x = MyCar.Position.x - 1
        y = MyCar.Position.y
        while x >= 0:
            MyMap[x][y].state = environment.GetState(Point(x, y))
            if MyMap[x][y].state == OCCUPIED:
                break
            x -= 1
    elif MyCar.Angle == 270:
        x = MyCar.Position.x
        y = MyCar.Position.y - 1
        while y >= 0:
            MyMap[x][y].state = environment.GetState(Point(x, y))
            if MyMap[x][y].state == OCCUPIED:
                break
            y -= 1
def Print(list):
    for i in range(len(list)):
        print(list[i])
def PrintState(MyMap):
    statemap = []
    for i in range(MapSize):
        statemap.append([])
        for j in range(MapSize):
            statemap[i].append(MyMap[i][j].state)
    print("state map after "+str(detection_cnt)+" detection" )
    Print(statemap)

            
if __name__ == "__main__":
    #initalize
    MyEnvironment = Environment(generate_random_map(MapSize))
    MyMap = [] #目前已知的地图信息
    MyCar = Car(Point(0, 0), 0)
    MapState = []
    for i in range(MapSize):
        MyMap.append([])
        for j in range(MapSize):
            MyMap[i].append(Point(i, j))
    MyMap[0][0].state = AVAILABLE

    PrintState(MyMap)
    Detect(MyCar, MyMap, MyEnvironment)
    PrintState(MyMap)
    
    

