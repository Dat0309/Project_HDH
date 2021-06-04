from tkinter import *
from tkinter.ttk import *
import os
from tkinter import filedialog

window = Tk()

def click():
    path = txt.get()
    
    fileName = txt2.get()
    
    try:
        if not os.path.exists(fileName):
            os.chdir(path)
            os.makedirs(fileName)
            if os.path.exists(fileName):
                lb3.configure(text='File đã tồn tại!')
            lb3.configure(text='Tạo mới thư mục thành công')
        
    except OSError:
        lb3.configure(text='Error: Đường dẫn không tồn tại!')

def check():
    filepath = filedialog.askopenfilename()
    print(filepath)

def reset():
    txt.delete(0,END)
    txt2.delete(0,END)

def exit():
    window.destroy()

window.title("Chương trình tạo file")

window.geometry('500x300')

frame1= Frame(window).pack(side=LEFT)
frame2 =Frame(window).pack(side=LEFT)


lbl = Label(frame1, text ="Tên thư mục").place(x=2,y=2)
#lbl.grid(column =0, row =0)
txt = Entry(frame1, width=50)
txt.pack()

#txt.grid(column=1, row=0)


lbl2 = Label(frame2, text ="Chọn đường dẫn")
lbl2.place(x=2,y=26)
#lbl2.grid(column =0, row =0)
txt2 = Entry(frame2, width=50)
txt2.pack()
#txt.grid(column=1, row=0)

frame3 = Frame(window).pack()
button = Button(frame3, text='Add File!',command=click).place(x=30,y=120)

checkbtn = Button(frame3,text="Check",command=check).place(x=100,y=120)
resetbtn = Button(frame3,text='Reset',command=reset).place(x=170,y=120)
exitbtn = Button(frame3,text='Exit',command=exit).place(x=300,y=120)
lb3 = Label(window,text='Xin mời nhập đường dẫn và tên thư mục cần tạo!',font=("Comic Sans",15))
lb3.pack()
window.mainloop()

