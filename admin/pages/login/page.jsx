import React from "react";
import {
  Card,
  Spacer,
  Button,
  Text,
  Input,
  Row,
  Checkbox,
  Container,
} from "@nextui-org/react";

export default function Login() {
  return (
    <div>
      <Container
        display="flex"
        alignItems="center"
        justify="center"
        css={{ minHeight: "100vh" }}
      >
        <Card css={{ mw: "420px", p: "20px" }} variant="bordered">
          <Text
            size={24}
            weight="bold"
            css={{
              as: "center",
              mb: "20px",
            }}
          >
            ADMIN DASHBORD
          </Text>
          <Input
            clearable
            bordered
            fullWidth
            color="primary"
            size="lg"
            placeholder="Email"
            contentLeft={<Mail fill="currentColor" />}
          />
          <Spacer y={1} />
          <Input
            clearable
            bordered
            fullWidth
            color="primary"
            size="lg"
            placeholder="Password"
            contentLeft={<Password fill="currentColor" />}
            css={{ mb: "6px" }}
          />
          <Row justify="space-between">
            <Checkbox>
              <Text size={14}>Remember me</Text>
            </Checkbox>
            <Text size={14}>Forgot password?</Text>
          </Row>
          <Spacer y={1} />
          <Button>Sign in</Button>
        </Card>
      </Container>
    </div>
  );
}
