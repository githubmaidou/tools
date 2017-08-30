import sys
class password:
    def __init__(self):
        try:
            and_file = open('dict/and.dict')
            ext_file = open('dict/ext.dict')
            pre_file = open('dict/pre.dict')
        except Exception as e:
            print("字典文件不存在")
            print("Error:%s" % e)
            exit()
        self.and_list = and_file.readlines()
        and_file.close()
        self.ext_list = ext_file.readlines()
        ext_file.close()
        self.pre_file = pre_file.readlines()
        pre_file.close()
        self.pass_list=[]
    def get(self,strkey,prelist,andlist,extlist):
        out_list = []
        try:
            strkey = str(strkey)
            for strpre in prelist:
                for strand in andlist:
                    for strext in extlist:
                        out_list.append(strpre.strip()+strkey+strand.strip()+strext.strip())
            self.dict_list = out_list
            return out_list
        except Exception as e:
            print("组合字典过程发生错误")
            print("Err:%s" % e)
            exit()

    def out_file(self,keyword,out_file_path):
        try:
            out_file_hand = open(out_file_path,'w')
        except Exception as e:
            print("创建输出文件失败")
            print("Err:%s" % e)
            exit()
        out_list = self.get(keyword,self.pre_file,self.and_list,self.ext_list)
        if len(self.pass_list) > 0:
            out_list = out_list + self.pass_list
        for dict_line in out_list:
            out_file_hand.write(dict_line+'\n')
        out_file_hand.close()

    def out_print(self,keyword):
        out_list = self.get(keyword, self.pre_file, self.and_list, self.ext_list)
        if len(self.pass_list) > 0:
            out_list = out_list + self.pass_list
        for dict_line in out_list:
            print(dict_line)

    def add_pass(self):
        pass_file_hand = open('dict/password.dict')
        pass_list = pass_file.hand.readlines()
        pass_file_hand.close()
        for pass_line in pass_list:
            self.pass_list.append(pass_line.strip())

pass_class = password()
if '--keyword' in sys.argv:
    keyword = sys.argv[sys.argv.index('--keyword') + 1]
    if '--pass' in sys.argv:
        pass_class.add_pass()
    if '--print' in sys.argv:
        pass_class.out_print(keyword)
    if '--file' in sys.argv:
        out_path = sys.argv[sys.argv.index('--file') + 1]
        pass_class.out_file(keyword,out_path)
else:
    print("--keyword    指定字符串")
    print("--pass       将dict/password.dict中的字典加入返回")
    print("--file path  将字典写入path")
    print("--print      直接输出")
    print("Eg:%s --keyword admin --print" % sys.argv[0])
    print("Eg:%s --keyword admin --file ./test.dict" % sys.argv[0])