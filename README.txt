sample run: "./spim -file GTU_OS_1.s"
>Enter
>integer
>integer
...

Process'ler arasında switch yapabiliyorum. İlk çalışmalarından sonra PC değerlerinin
Process table'dan güncelliyorum fakat ikinci bir process çalıştığında PC değerleri
geri mainlerine(label) set oluyor. Bu sorunun sebebini çözemedim.

Processleri yüklediğimde PC'lerini set etmek için spim'in "find_symbol_address" 
fonksiyonunu kullandım ve main label'larına set ettim.


Yaptıklarım:
1) Process sınıfı oluşturuldu. Bu sınıf içerisinde save/restore State metodları 
yazıldı. Bu metodlar sayesinde register içeriğinin yedeklenmesi ve geri yüklenmesi 
sağlandı.

2) Process table sınıfı oluşturuldu. Bu sınıf C++ vector sınıf ile process'ler 
tutuyor ve bunların düzenlenmesi için kullanıldı. PID alıp, Process referansı 
döndüren getProcess() metodu var.

3) context_switch fonksiyonu process 1-2-3 arasında seçip yapıp biten process'in 
saveState metodunu çağırıyor. Yeni başlıyacak process'in restoreState metodunu 
çağırıyor. Son olarak yeni başlayacak process'in PC'i ile run_spim'i çağırıyor. 
Bu işlem timer interrupt sırasında gerçekleşiyor.

4)read_assembly_file_no_flush fonksiyonu spim'in kendi read_assemly fonksiyonuna 
benzer fakat memory'i flush'lamıyor. Bu sayade 1'den fazla *.asm dosyasını 
load edebiliyoruz.


