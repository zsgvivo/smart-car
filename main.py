# file: quit_button.py
#!/usr/bin/python

"""
ZetCode PyQt6 tutorial

This program creates a quit
button. When we press the button,
the application terminates.

Author: Jan Bodnar
Website: zetcode.com
"""

import sys
import random
from PyQt6.QtWidgets import QWidget, QPushButton, QApplication
from PyQt6.QtGui import QPainter
import sys
from PyQt6.QtWidgets import QApplication, QWidget, QComboBox, QPushButton, QHBoxLayout, QVBoxLayout, QColorDialog
from PyQt6.QtGui import QIcon, QPainter, QPen, QColor, QPolygon
from PyQt6.QtCore import Qt, QPoint
class Example(QWidget):

    def __init__(self):
        super().__init__()

        self.initUI()

    def initUI(self):

        qbtn = QPushButton('Quit', self)
        qbtn.clicked.connect(QApplication.instance().quit)
        qbtn.resize(qbtn.sizeHint())
        qbtn.move(600, 500)
        # qbtn.resize(50, 50)

        leftbtn = QPushButton('left', self)
        leftbtn.resize(50, 50)
        leftbtn.move(125,100)

        rightbtn = QPushButton('right', self)
        rightbtn.resize(50, 50)
        rightbtn.move(225,100)

        upbtn = QPushButton('up', self)
        upbtn.resize(50, 50)
        upbtn.move(175, 50)

        downbtn = QPushButton('down', self)
        downbtn.resize(50, 50)
        downbtn.move(175, 150)

        self.drawbtn = QPushButton('draw trajectory', self)
        # drawbtn.clicked.connect()
        self.drawbtn.resize(self.drawbtn.sizeHint())
        self.drawbtn.move(400, 500)
        self.setGeometry(300, 300, 700, 600)
        self.setMinimumSize(700, 600)
        self.setWindowTitle('Quit button')
        self.show()
class Canvas(QWidget):
    """从QWidget类派生的桌面应用程序窗口类"""

    def __init__(self):
        """构造函数"""

        super().__init__()

        self.setWindowTitle('画板')
        self.setWindowIcon(QIcon('res/qt.png'))
        self.resize(480, 320)

        self.initUI()
        # self.show()
        # self.center()

    def center(self):
        """窗口在屏幕上居中"""

        win_rect = self.frameGeometry()
        scr_center = self.screen().availableGeometry().center()
        win_rect.moveCenter(scr_center)
        self.move(win_rect.topLeft())

    def initUI(self):
        """初始化界面"""

        self.pen_c = '#90f010'  # 当前颜色
        self.pen_w = 3  # 当前画笔宽度
        self.isDrag = False  # 鼠标键按下标志

        self.contents = list()  # 图元
        self.setMouseTracking(True)  # 开启感知鼠标移动轨迹

        # btn_color = QPushButton('')
        # btn_color.setStyleSheet('background-color:%s' % self.pen_c)
        # btn_color.clicked.connect(self.on_color)
        #
        # cb = QComboBox()
        # cb.addItems(['1pix', '3pix', '5pix', '7pix', '9pix'])
        # cb.setCurrentText('%dpix' % self.pen_w)
        # cb.currentIndexChanged.connect(self.on_combobox)

        vbox = QVBoxLayout()
        vbox.addSpacing(20)
        # vbox.addWidget(btn_color)
        vbox.addSpacing(10)
        # vbox.addWidget(cb)
        vbox.addStretch(1)

        hbox = QHBoxLayout()
        hbox.addStretch(1)
        hbox.addLayout(vbox)

        self.setLayout(hbox)
        clearbtn = QPushButton('clear', self)
        clearbtn.clicked.connect(self.contents.clear)
        clearbtn.resize(clearbtn.sizeHint())
        clearbtn.move(400, 250)
    # def on_combobox(self, evt):
    #     """选择画笔宽度"""
    #
    #     self.pen_w = int(self.sender().currentText()[:-3])
    #
    # def on_color(self):
    #     """选择颜色"""
    #
    #     color = QColorDialog.getColor()
    #     if color.isValid():
    #         self.pen_c = color.name()
    #         self.sender().setStyleSheet('background-color:%s' % self.pen_c)

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


def main():

    app = QApplication(sys.argv)
    ex = Example()
    canvas = Canvas()
    ex.drawbtn.clicked.connect(canvas.show)
    sys.exit(app.exec())


if __name__ == '__main__':
    main()
