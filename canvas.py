from PyQt6.QtWidgets import QWidget, QPushButton, QHBoxLayout, QVBoxLayout
from PyQt6.QtGui import QPainter, QPen, QColor, QPolygon
from PyQt6.QtCore import Qt, QPoint
class Canvas(QWidget):
    """从QWidget类派生的桌面应用程序窗口类"""
    def __init__(self):
        """构造函数"""
        super().__init__()
        self.setWindowTitle('Canvas')
        self.resize(480, 320)
        self.initUI()

    def initUI(self):
        """初始化界面"""
        self.pen_c = '#90f010'  # 当前颜色
        self.pen_w = 3  # 当前画笔宽度
        self.isDrag = False  # 鼠标键按下标志

        self.contents = list()  # 图元
        self.setMouseTracking(True)  # 开启感知鼠标移动轨迹
        clearbtn = QPushButton('clear', self)
        clearbtn.clicked.connect(self.contents.clear)
        clearbtn.resize(clearbtn.sizeHint())
        # clearbtn.move(400, 250)
        self.sendbtn = QPushButton('send', self)
        self.sendbtn.resize(self.sendbtn.sizeHint())
        vbox = QVBoxLayout()
        vbox.addSpacing(20)
        vbox.addWidget(clearbtn)
        vbox.addSpacing(10)
        vbox.addWidget(self.sendbtn)
        vbox.addStretch(1)

        hbox = QHBoxLayout()
        hbox.addStretch(1)
        hbox.addLayout(vbox)

        self.setLayout(hbox)


    def mousePressEvent(self, evt):
        """按下鼠标按键"""
        self.isDrag = True
        pos = evt.position()
        self.contents.append(dict({'pen_c': self.pen_c, 'pen_w': self.pen_w, 'points': [QPoint(pos.x(), pos.y())]}))

    def mouseReleaseEvent(self, evt):
        """释放鼠标按键"""
        self.isDrag = False

    def mouseMoveEvent(self, evt):
        """鼠标移动事件"""
        if self.isDrag:
            pos = evt.position()
            self.contents[-1]['points'].append(QPoint(pos.x(), pos.y()))
            self.update()

    def paintEvent(self, evt):
        """响应重绘事件"""
        painter = QPainter(self)
        for item in self.contents:
            painter.setPen(QPen(QPen(QColor(item['pen_c']), item['pen_w'], Qt.PenStyle.SolidLine)))
            painter.drawPolyline(QPolygon(item['points']))