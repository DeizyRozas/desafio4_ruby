require 'uri'
require 'net/http'
require 'json'

def request(url_requested)
    url = URI(url_requested)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true 
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER #con esto evitamos ala vulnerabilidad
    request = Net::HTTP::Get.new(url)
    request["cache-control"] = 'no-cache'
    request["postman-token"] = '5f4b1b36-5bcd-4c49-f578-75a752af8fd5'
    response = http.request(request)
    return JSON.parse(response.body) #convierte la respuesta en hash
end

# esta variable data contiene el llamado al metodo que devuelve el hash con la respuesta
# mi apikey ==> cbMmyk26c1v4E9GdEt85e3ebQjBHZWXPONu6dQ5b 
data = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=100&camera=navcam&api_key=cbMmyk26c1v4E9GdEt85e3ebQjBHZWXPONu6dQ5b')


def buid_web_page (data)
    #variable con el inicio de lo que tendra el html + el recorrido del hash de respuesta
    html='<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
    </head>
    <body>
        <ul>'

    #data es un hash con una unica clave = ["photos"] que contiene una matriz de arreglos conformada de hashes
    data["photos"].each do |elemento|
        #se insertan los elementos en el html 
        html= html+ "<li><img src='#{elemento["img_src"]}' alt=''></li>\n"
    end
    html+="</ul>\n</body>\n</html>"

    #se crea el archivo html y se le pasa como parametro la variable html que contiene toda la info procesada
    File.write("pagina.html", html)

end

buid_web_page(data)

#Crear un método photos_count que reciba el hash de respuesta y devuelva un nuevo hash con el nombre de la cámara y la cantidad de fotos.

def photos_count(data)
    nuevo_hash=Hash.new
    contador_fotos=0
    data["photos"].each do |elemento|
        nuevo_hash[elemento["camera"]["name"]]=contador_fotos
        contador_fotos+=1        
    end
    puts " el hash con en nombre de la camara y numero de fotos --> #{nuevo_hash}"

end

photos_count(data)