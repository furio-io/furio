<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="tag-manager-container-id" content="{{ $tagManagerContainerId }}">
        <link href="{{ mix('css/app.css') }}" rel="stylesheet">
        <title>{{ config('app.name') }}</title>
    </head>
    <body>
        <div id="app">
            <App
                tag-manager-container-id="{{ $tagManagerContainerId }}"
                network-id="{{ $networkId }}"
                network-name="{{ $networkName }}"
                rpc="{{ $rpc }}"
                recaptcha="{{ $recaptcha }}"
                usdc-address="{{ $usdcAddress }}"
                usdc-abi="{{ $usdcAbi }}"
                presale-nft-address="{{ $presaleNftAddress }}"
                presale-nft-abi="{{ $presaleNftAbi }}"
            />
        </div>
        <script src="{{ mix('js/main.js') }}"></script>
    </body>
</html>
