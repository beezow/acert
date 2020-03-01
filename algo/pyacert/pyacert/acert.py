#!/usr/bin/env python3
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *


class PicButton(QAbstractButton):
    def __init__(self, pixmap, parent=None):
        super(PicButton, self).__init__(parent)
        self.pixmap = pixmap

    def paintEvent(self, event):
        painter = QPainter(self)
        painter.drawPixmap(event.rect(), self.pixmap)

    def sizeHint(self):
        return self.pixmap.size()

key_file = ""
vid_file = ""

def load_file():
    file_diag = QFileDialog()
    file_diag.setFileMode(QFileDialog.AnyFile)
  #  filename = QStringList()
    file_diag.exec_()
    return file_diag.selectedFiles()[0]

def load_vid():
    vid_file = load_file()
def load_key():
    key_file = load_file()

def on_sign_clicked():
    alert = QMessageBox()
    alert.setText('Successfully Signed')
    alert.exec_()

def on_verify_clicked():
    alert = QMessageBox()
    alert.setText('Video is Signed')
    alert.exec_()

if __name__ == "__main__":
    app = QApplication([])

    app.setStyle("Fusion")

    dark_palette = QPalette()

    dark_palette.setColor(QPalette.Window, QColor(53, 53, 53))
    dark_palette.setColor(QPalette.WindowText, QColor(255,255,255))
    dark_palette.setColor(QPalette.Base, QColor(25, 25, 25))
    dark_palette.setColor(QPalette.AlternateBase, QColor(53, 53, 53))
    dark_palette.setColor(QPalette.ToolTipBase, QColor(255,255,255))
    dark_palette.setColor(QPalette.ToolTipText, QColor(255,255,255))
    dark_palette.setColor(QPalette.Text, QColor(255,255,255))
    dark_palette.setColor(QPalette.Button, QColor(53, 53, 53))
    dark_palette.setColor(QPalette.ButtonText, QColor(255,255,255))
    dark_palette.setColor(QPalette.BrightText, QColor(255,0,0))
    dark_palette.setColor(QPalette.Link, QColor(42, 130, 218))
    dark_palette.setColor(QPalette.Highlight, QColor(42, 130, 218))
    dark_palette.setColor(QPalette.HighlightedText, QColor(0,0,0))

    app.setPalette(dark_palette)

    app.setStyleSheet("QToolTip { color: #ffffff; background-color: #2a82da; border: 1px solid white; }")    


    window = QWidget()
    layout = QVBoxLayout()

    img_button = PicButton(QPixmap("check.png"))
    img_button.clicked.connect(load_key)
    layout.addWidget(img_button)
    key_button = QPushButton('Select Key File')
    key_button.clicked.connect(load_vid)

    layout.addWidget(key_button)
    but_layout = QHBoxLayout()
   
    ver_button = QPushButton('Verify')
    sig_button = QPushButton('Sign')
    ver_button.clicked.connect(on_verify_clicked)
    sig_button.clicked.connect(on_sign_clicked)
    but_layout.addWidget(ver_button)
    but_layout.addWidget(sig_button)

    layout.addLayout(but_layout)
    window.setLayout(layout)
    window.show()
    app.exec_()

