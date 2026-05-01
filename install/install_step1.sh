UPGRADE="No"

echo "Let's get started with a apt upgrade"
if [ "$UPGRADE" == "Yes" ]; then
    sudo apt upgrade --refresh -y
fi

echo "Installing PHP and PHP modules..."
sudo apt install -y php php-cli php-common php-fpm php-json php-pdo php-mbstring php-xml php-opcache php-curl php-zip php-intl php-gd php-bcmath php-xmlrpc
sudo apt install php8.2-mysql
if ! sudo apt install -y php; then
    echo "Failed to install PHP. Exiting."
    exit 1
fi

echo "Installing Nginx..."
sudo apt install -y nginx
sudo ufw allow 'Nginx HTTP'
# If missing:
#	sudo nano /etc/ufw/applications.d/nginx
#[Nginx HTTP]
#title=Web Server
#description=HTTP traffic
#ports=80


echo "Installing Laravel Composer..."
if ! command -v composer >/dev/null 2>&1; then
	sudo apt install -y composer
fi

echo "Setup Laravel Scout"
sudo composer require laravel/scout
sudo php artisan vendor:publish --provider="Laravel\Scout\ScoutServiceProvider"

echo "Installing NGINX..."
sudo apt install nginx -y

echo "Enabling and starting NGINX..."
sudo systemctl start nginx
sudo systemctl enable nginx

echo "Setting up firewall..."
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload

echo "MariaDB setup..."
sudo apt install mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation
sudo apt install php-mysqlnd

echo "Setup marketpalce DB in Maria/MySQL..."
echo ""
echo "OK, this part needs to be done manually (see install_step2.txt), then you can continue to run install_step3.sh"
echo "Setup your root password for MariaDB then run mysql --defaults-file=${CONFIG_FILE} -e "CREATE DATABASE>""



