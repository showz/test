<?php

$hamburger = $argv[1];
$potato = $argv[2];
$drink = $argv[3];
$debug = isset($argv[4]) && $argv[4] ? true : false;

$CALC = new Calc($hamburger, $potato, $drink, $debug);
$CALC->exec();
printf("合計は %d になります。", $CALC->getTotalPrice());


class Calc {
    private $total_price = 0;
    private $hamburger;
    private $potato;
    private $drink;
    private $debug;
    private $hamburger_price = 250;
    private $potato_price = 200;
    private $drink_price = 150;
    private $set_price = 550;
    private $keys = array('hamburger', 'potato', 'drink');

    public function __construct($hamburger=0, $potato=0, $drink=0, $debug=false)
    {
        foreach($this->keys as $k){
            if(is_numeric($$k) && $$k > 0){
                $this->{$k} = $$k;
            }
        }
        if(is_bool($debug)){
            $this->debug = $debug;
        }else{
            $this->debug = false;
        }
    }

    public function exec()
    {
        $minimum = false;
        foreach($this->keys as $k){
            if(!$minimum || ($minimum > $this->{$k})){
               $minimum = $this->{$k};
            }
        }

        $this->total_price += $this->set_price * $minimum;
        $this->total_price += $this->hamburger_price * ($this->hamburger - $minimum);
        $this->total_price += $this->potato_price * ($this->potato - $minimum);
        $this->total_price += $this->drink_price * ($this->drink - $minimum);
        if($this->debug){
            print 'minimum : '.$minimum.PHP_EOL;
            print 'total set price : '.($this->set_price * $minimum).PHP_EOL;
            print 'hamburger num : '.$this->hamburger.PHP_EOL;
            print 'hamburger total price : '.($this->hamburger_price * ($this->hamburger - $minimum)).PHP_EOL;
            print 'potato num : '.$this->potato.PHP_EOL;
            print 'potato total price : '.($this->potato_price * ($this->potato - $minimum)).PHP_EOL;
            print 'drink num : '.$this->drink.PHP_EOL;
            print 'drink total price : '.($this->drink_price * ($this->drink - $minimum)).PHP_EOL;
        }

        return true;
    }

    public function getTotalPrice()
    {
        return $this->total_price;
    }
}
