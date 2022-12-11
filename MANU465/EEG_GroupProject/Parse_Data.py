# cd desktop/testingsetup
# python3 showpics.py


import os
import csv


class controller:
    def __init__(self):
        #find current directory
        self.path_code = os.getcwd()

    def main(self):
        #run main code block

        #find and mathc up CSV files
        csv_pairs = C.match_csvs()

        #for each pair of CSV's split recording into individual images
        C.parse_pairs(csv_pairs)

    def get_date_time(self,file):
        a = ''.join(filter(str.isdigit, file))
        if len(a) == 14:
            a = a + "000000"
        return a
                    
    def match_csvs(self):
        csv_pairs = [[],[]]

        for root,dirs,files in os.walk(C.path_code + "/Comp"):
            for file_c in files:
                if file_c.endswith(".csv"):
                    date_time_c = C.get_date_time(file_c)
                    dif = int(date_time_c)

                    for root,dirs,files in os.walk(C.path_code + "/Muse"):
                        for file_m in files:
                            if file_m.endswith(".csv"):
                                date_time_m = C.get_date_time(file_m)

                                if abs(int(date_time_m) - int(date_time_c)) < dif:
                                    dif = abs(int(date_time_m) - int(date_time_c))
                                    best_m = file_m
                                    best_time_m = date_time_m
                    if dif > 100 * 1000000:
                        print("TOO LONG")
                        best_m = 'none'
                    else:
                        csv_pairs[0].append(file_c)
                        csv_pairs[1].append(best_m)

        print("Paired up " + str(len(csv_pairs[0])) + " csv files")
        return csv_pairs

    def parse_pairs(self,csv_pairs):
            num_pairs = len(csv_pairs[1])
            
            for i in range(num_pairs):
                path_parsed = C.path_code + "/Parsed" #+ "/" + str(C.get_date_time(csv_pairs[1][i]))
                if not os.path.exists(path_parsed):
                    os.makedirs(path_parsed)

                    for j in range(5):
                        os.makedirs(path_parsed + "/" + str(j+1))

                comp_csv_data = C.get_comp_data(csv_pairs,i)
                muse_csv_data = C.get_muse_data(csv_pairs,i)

                C.parse_muse_data(muse_csv_data,comp_csv_data,path_parsed)

                    
    def get_comp_data(self,csv_pairs,i):

        comp_csv_data = []

        file_c = C.path_code + "/Comp" + "/" + csv_pairs[0][i]
        with open(file_c, 'r') as f:
            reader = csv.reader(f, delimiter=',')
            for row in reader:
                date_time_i = C.get_date_time(row[3])
                comp_csv_data.append([row[0],date_time_i,row[2]])

            return comp_csv_data

    def get_muse_data(self,csv_pairs,i):

        muse_csv_data = []

        file_m = C.path_code + "/Muse" + "/" + csv_pairs[1][i]
        with open(file_m, 'r') as f:
            reader = csv.reader(f, delimiter=',')
            for row in reader: 
                date_time_r = C.get_date_time(row[0])
                # muse_csv_data.append([date_time_r,row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8]])
                muse_csv_data.append([date_time_r])
                for i in range(25):
                    muse_csv_data[-1].append(row[i+1])

            
            return muse_csv_data

    def parse_muse_data(self,muse_csv_data,comp_csv_data,path_parsed):
        r = 0

        for i in comp_csv_data[1:]:
            t_start =i[1]
            # print(i[2])
            if int(i[2]) >= 1 and int(i[2]) <= 5:
                 
                for j in range(len(muse_csv_data) -1 - r):
                    # print(len(muse_csv_data))
                    # print(j+1+r)

                    if int(muse_csv_data[j+1+r][0]) > int(t_start[:-3]):
                        # print("Image number: " + i[0])
                        # print("Image shown at: " + t_start[8:-3])
                        # print("First reading at: " + muse_csv_data[j+1+r][0][8:])

                        t_end = str(int(t_start) + 5000000)

                        r = j+r

                        break

                for k in range(len(muse_csv_data) -1 - r):
                    # print(len(muse_csv_data))
                    # print(j+1+r)

                    if int(muse_csv_data[k+1+r][0]) > int(t_end[:-3]):
                        # print("Image number: " + i[0])
                        # print("Image end at: " + t_end[8:-3])
                        # print("last reading at: " + muse_csv_data[k+r][0][8:])


                        r = k+r

                        break
                    else:
                        # print(muse_csv_data[k+1+r][0][8:])
                        # open the file in the write mode

                        if muse_csv_data[k+1+r][1] != '':
                            with open(path_parsed + "/" + i[2] + "/" + str(C.get_date_time(comp_csv_data[1][1])) + "_image_" + i[0] + ".csv", 'a') as f:
                                # create the csv writer
                                writer = csv.writer(f)

                                # write a row to the csv file
                                row = muse_csv_data[k+1+r]

                                year = muse_csv_data[k+1+r][0][:3]
                                month = muse_csv_data[k+1+r][0][4:5]
                                day = muse_csv_data[k+1+r][0][6:7]

                                hour = muse_csv_data[k+1+r][0][8:9]
                                minute = muse_csv_data[k+1+r][0][10:11]
                                second = muse_csv_data[k+1+r][0][12:]


                                date_time_formated = f"{year}-{month}-{day} {hour}:{minute}:{second}"



                                row[0] = date_time_formated
                                row.append(i[2])
                                writer.writerow(row)
                                print(row)


            # print("\n\n")

                    


C = controller()

if __name__ == "__main__":
    run = True

    C.main() # Run the main program







