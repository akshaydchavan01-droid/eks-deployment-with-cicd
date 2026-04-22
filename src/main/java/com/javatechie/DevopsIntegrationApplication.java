package com.javatechie;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class DevopsIntegrationApplication {

    @GetMapping("/")
    public String message() {
        return """
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Akshay DevOps Project</title>
                    <style>
                        body {
                            margin: 0;
                            font-family: Arial, sans-serif;
                            background: linear-gradient(to right, #1e3c72, #2a5298);
                            color: white;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            height: 100vh;
                        }
                        .container {
                            text-align: center;
                            background: rgba(0, 0, 0, 0.3);
                            padding: 40px;
                            border-radius: 12px;
                            box-shadow: 0 8px 20px rgba(0,0,0,0.4);
                        }
                        h1 {
                            margin-bottom: 10px;
                        }
                        p {
                            font-size: 18px;
                            margin-top: 0;
                        }
                        .tag {
                            margin-top: 20px;
                            padding: 10px 20px;
                            background: #00c6ff;
                            border-radius: 20px;
                            display: inline-block;
                            color: black;
                            font-weight: bold;
                        }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <h1>🚀 Akshay DevOps Project</h1>
                        <p>Spring Boot + Docker + Kubernetes + CI/CD</p>
                        <div class="tag">Successfully Running ✔</div>
                    </div>
                </body>
                </html>
                """;
    }

    public static void main(String[] args) {
        SpringApplication.run(DevopsIntegrationApplication.class, args);
    }
}
