import sys
from PyQt6.QtWidgets import QApplication, QWidget, QPushButton, QHBoxLayout, QVBoxLayout
from clicker import ClickerWindow
from canvas import Canvas
class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        #遥控器
        self.clickbtn = QPushButton('遥控器', self)
        self.clickbtn.move(25, 25)
        self.clickbtn.resize(self.clickbtn.sizeHint())

        #用鼠标绘制轨迹
        self.drawbtn = QPushButton('draw trajectory', self)
        self.drawbtn.resize(self.drawbtn.sizeHint())
        # self.drawbtn.move(400, 500)

        #退出界面
        self.qbtn = QPushButton('Quit', self)
        self.qbtn.clicked.connect(QApplication.instance().quit)
        self.qbtn.resize(self.qbtn.sizeHint())
        # self.qbtn.move(600, 500)
        # qbtn.resize(50, 50)

        hbox = QHBoxLayout()
        hbox.addStretch(1)
        hbox.addWidget(self.drawbtn)
        hbox.addWidget(self.qbtn)

        vbox = QVBoxLayout()
        vbox.addStretch(1)
        vbox.addLayout(hbox)

        self.setLayout(vbox)

        self.setGeometry(300, 300, 200, 200)
        # self.setMinimumSize(400, 300)
        self.setWindowTitle('Smart Car')
        self.show()

def main():

    app = QApplication(sys.argv)
    ex = MainWindow()
    canvas = Canvas()
    clicker = ClickerWindow()
    ex.clickbtn.clicked.connect(clicker.show)
    ex.drawbtn.clicked.connect(canvas.show)
    sys.exit(app.exec())


if __name__ == '__main__':
    main()
